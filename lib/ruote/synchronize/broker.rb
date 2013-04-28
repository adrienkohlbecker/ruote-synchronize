# encoding: UTF-8

module Ruote
  module Synchronize

    class Broker

      include Ruote::ReceiverMixin

      def initialize(context)
        @context = context
      end

      def publish(key, workitem)

        if doc = stored_doc_from_key(key)
          # another process already registered the same key
          # allow both processes to continue
          continue_with doc
          true
        else
          # this process is the first to register
          # store the workitem for now
          wait_for key, workitem
          false
        end

      end

      def unpublish(key)
        doc = stored_doc_from_key(key)
        @context.storage.delete(doc) if doc
      end

      private

      def stored_doc_from_key(key)
        @context.storage.get('synchronize', key)
      end

      def continue_with(doc)

        stored_workitem = Ruote::Workitem.new(doc['workitem'])
        receive(stored_workitem)
        @context.storage.delete(doc)

      end

      def wait_for(key, workitem)

        doc = {
          'type' => 'synchronize',
          '_id' => key,
          'workitem' => workitem.to_h
        }
        @context.storage.put(doc)

      end


    end

  end
end
