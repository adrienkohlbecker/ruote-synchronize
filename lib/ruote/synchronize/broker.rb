module Ruote
  module Synchronize

    class Broker

      include ReceiverMixin

      def initialize(context)
        @context = context
        @context.storage.add_type('synchronize')
        @context.dashboard.register_participant 'synchronize', Ruote::Synchronize::Participant
      end

      def publish(key, workitem=nil)

        ret = @context.storage.get('synchronize', key)
        if ret
          ret_workitem = ret['workitem']
          receive(ret_workitem) unless ret_workitem.nil?
          @context.storage.delete(ret)
          return true
        else

          doc = {
            'type' => 'synchronize',
            '_id' => key,
            'workitem' => workitem
          }
          @context.storage.put(doc)

          return false

        end

      end

      def unpublish(key)

        if doc = @context.storage.get('synchronize', key)
          @context.storage.delete(doc)
        end

      end

    end

  end
end
