# encoding: UTF-8

require 'spec_helper'
require 'ruote/storage/fs_storage'

describe Ruote::Synchronize::Broker do

  before :each do
    @board = Ruote::Dashboard.new(Ruote::Worker.new(Ruote::FsStorage.new('ruote_work')))
    @participant = Ruote::Synchronize::Participant.new
    @participant.context = @board.context
  end

  after :each do
    @board.shutdown
    @board.storage.purge!
  end

  context '#on_workitem' do

    let(:workitem) { Ruote::Workitem.new({'abc' => true, 'fields' => {'params' => {'key' => 'my_key'}}}) }
    let(:key) { 'my_key' }

    it 'raises if the key is not defined' do
      workitem.fields['params']['key'] = nil
      expect{@participant._on_workitem(workitem)}.to raise_error(Ruote::Synchronize::UndefinedKey)
    end

    context 'with a fresh storage' do

      it 'stores the message' do
        @participant._on_workitem(workitem)
        expect(@board.context.storage.get('synchronize', key)).not_to be_nil
      end

      it 'does not reply' do
        @participant.should_not_receive(:reply)
        @participant._on_workitem(workitem)
      end

    end

    context 'with a previous message' do

      before :each do
        @another_participant = Ruote::Synchronize::Participant.new
        @another_participant.context = @board.context
        @another_participant._on_workitem(workitem)
      end

      it 'replies to the other participant' do
        Ruote::Synchronize::Broker.any_instance.should_receive(:receive).with(@another_participant.workitem)
        @participant._on_workitem(workitem)
      end

      it 'replies immediately' do
        @participant.should_receive(:reply)
        @participant._on_workitem(workitem)
      end

    end

  end

  context '#on_cancel' do

    let(:workitem) { Ruote::Workitem.new({'abc' => true, 'fields' => {'params' => {'key' => 'my_key'}}}) }
    let(:key) { 'my_key' }

    it 'deletes the message' do

      @participant._on_workitem(workitem)
      @participant.stub(:applied_workitem).and_return workitem
      @participant.on_cancel
      expect(@board.context.storage.get('synchronize', key)).to be_nil

    end

  end

end
