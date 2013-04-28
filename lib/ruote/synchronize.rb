# encoding: UTF-8

require 'ruote'
require 'ruote/synchronize/broker'
require 'ruote/synchronize/participant'
require 'ruote/synchronize/version'

module Ruote

  # A process synchronisation module for Ruote.
  #
  # Will define a `synchronize :key => "my_unique_key"` participant.
  # You can use it in two processes by defining the same synchronisation key.
  # The first process to reach the synchronization will wait for the other one.
  #
  # It works by storing the first workitem along with the key.
  # When the second process reaches synchronize, it will find the previous workitem,
  # receive it (allowing the first process to proceed), and reply immediately.
  #
  # You must use a key that you know will NEVER be used outside of the two process you want to synchronize.
  #
  # Pay attention to multiple launches (if your process is launched by an HTTP request for example).
  # If three processes with the same key are launched, the two first will be synchronized and the last one will be left hanging.
  #
  # @example Charly and Doug will only run when both Alice and Bob have run, no matter which one of Alice or Bob finishes first
  #
  #     Ruote::Synchronize.setup(engine)
  #
  #     pdef1 = Ruote.process_definition do
  #       alice
  #       synchronize :key => 'my_very_unique_key'
  #       charly
  #     end
  #
  #     pdef2 = Ruote.process_definition do
  #       bob
  #       synchronize :key => 'my_very_unique_key'
  #       doug
  #     end
  module Synchronize

    # Will register the `synchronize` storage type and participant.
    # You need to execute this method before launching any processes.
    # @param [Ruote::Dashboard, Ruote::Engine] dashboard your Ruote dashboard.
    # @return [void]
    def self.setup(dashboard)

      dashboard.context.storage.add_type 'synchronize'
      dashboard.register_participant 'synchronize', Ruote::Synchronize::Participant

    end

  end
end
