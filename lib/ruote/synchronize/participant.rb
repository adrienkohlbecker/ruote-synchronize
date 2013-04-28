# encoding: UTF-8

module Ruote
module Synchronize

  class UndefinedKey < RuntimeError
  end

  class Participant

    include Ruote::LocalParticipant

    def on_workitem

      key = workitem.lookup('params.key')
      raise UndefinedKey if key.to_s.empty?

      reply if broker.publish(key, workitem)

    end

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
