module Ruote
module Synchronize

  class Participant

    include Ruote::LocalParticipant

    def broker
      @broker ||= Ruote::Synchronize::Broker.new(self.context)
    end

    def on_workitem

      key = workitem.fields['params']['key']
      raise "Key is not defined" if key.nil?

      if broker.publish(key, workitem.to_h)
        reply
      end

    end

    def on_cancel

      key = applied_workitem.fields['params']['key']
      broker.unpublish(key)

    end

  end
end
end
