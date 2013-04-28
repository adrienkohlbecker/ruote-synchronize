# encoding: UTF-8

require 'ruote'
require 'ruote/synchronize/broker'
require 'ruote/synchronize/participant'
require 'ruote/synchronize/version'

module Ruote
  module Synchronize

    def self.setup(dashboard)

      dashboard.context.storage.add_type 'synchronize'
      dashboard.register_participant 'synchronize', Ruote::Synchronize::Participant

    end

  end
end
