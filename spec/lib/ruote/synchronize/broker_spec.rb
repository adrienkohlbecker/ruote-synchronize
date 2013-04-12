require 'spec_helper'

describe Ruote::Synchronize::Broker do

  before :each do

    @board = Ruote::Dashboard.new(Ruote::Worker.new(Ruote::HashStorage.new))

    @board.register /^block_/ do |workitem|
      workitem.fields[workitem.participant_name] = 'was here'
    end

  end

  after :each do

    @board.shutdown
    @board.storage.purge!

  end

  context '#initialize' do

    it 'accepts a context' do

      expect{Ruote::Synchronize::Broker.new}.to raise_error
      expect{Ruote::Synchronize::Broker.new(@board.context)}.not_to raise_error

    end

    it 'registers the synchronize participant' do

      sync = Ruote::Synchronize::Broker.new(@board.context)
      expect(@board.participant('synchronize')).not_to be_nil
      expect(@board.participant('synchronize').class).to eq(Ruote::Synchronize::Participant)

    end

  end

  context '#publish' do

    let(:sync) { Ruote::Synchronize::Broker.new(@board.context) }
    let(:key) { 'my_key' }
    let(:workitem) { {'abc'=> true} }

    context 'with a fresh storage' do

      it 'stores the workitem with the message' do
        sync.publish(key, workitem)
        expect(@board.context.storage.get('synchronize', key)['workitem']).to eq(workitem)
      end

      it 'returns false' do
        expect(sync.publish(key, workitem)).to be_false
      end

    end

    context 'with a previously published message' do

      before :each do
        sync.publish(key, workitem)
      end

      let(:another_workitem) { {:def => true}  }

      it 'deletes the previous message' do
        sync.publish(key, another_workitem)
        expect(@board.context.storage.get('synchronize', key)).to be_nil

      end

      it 'returns true' do
        expect(sync.publish(key, another_workitem)).to be_true
      end

      it 'receives the previous workitem' do
        sync.should_receive(:receive).with(workitem)
        sync.publish(key, another_workitem)
      end

    end


  end

  context '#unpublish' do

    let(:sync) { Ruote::Synchronize::Broker.new(@board.context) }
    let(:key) { 'my_key' }
    let(:workitem) { {'abc'=> true} }

    context 'with a fresh storage' do

      it 'returns nil' do
        expect(sync.unpublish(key)).to be_nil
      end

    end

    context 'with a previously published message' do

      before :each do
        sync.publish(key, workitem)
      end

      it 'deletes the previous message' do
        sync.unpublish(key)
        expect(@board.context.storage.get('synchronize', key)).to be_nil
      end

    end


  end


end
