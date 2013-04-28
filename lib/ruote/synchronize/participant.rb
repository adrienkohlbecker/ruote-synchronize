# encoding: UTF-8

module Ruote
module Synchronize

  # Raised when the synchronize participant is used without a key
  # @example Will raise UndefinedKey during process execution
  #     pdef = Ruote.process_definition do
  #       synchronize
  #       synchronize :key => nil
  #       synchronize :key => ''
  #     end
  class UndefinedKey < RuntimeError
  end

  # A special kind of participant registered as "synchronize"
  class Participant

    include Ruote::LocalParticipant

    # Replies if another synchronize call was made previously with the same key.
    # Otherwise stores the workitem and does not reply.
    # @raise [UndefinedKey] if synchronize was called with a nil or empty key.
    # @return [void]
    def on_workitem

      key = workitem.lookup('params.key')
      raise UndefinedKey if key.to_s.empty?

      reply if broker.publish(key, workitem)

    end

    # Deletes the synchronization key from storage if it still exists.
    # @return [void]
    def on_cancel

      key = applied_workitem.lookup('params.key')
      broker.unpublish(key)

    end

    private

    def broker
      @broker ||= Ruote::Synchronize::Broker.new(self.context)
    end

  end
end
end
