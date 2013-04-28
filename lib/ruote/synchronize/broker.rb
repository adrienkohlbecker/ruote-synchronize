# encoding: UTF-8

module Ruote
  module Synchronize

    # A Ruote Receiver that act as a broker between two processes.
    # It will store workitems under the `synchronize` storage type.
    class Broker

      include Ruote::ReceiverMixin

      # @param [Ruote::Context] context (needed by Ruote)
      def initialize(context)
        @context = context
      end

      # Check if there was a previous workitem stored with the same key.
      # If so, receives and deletes the stored workitem.
      # Else, stores the workitem with the key.
      # @param [#to_s] key The unique key to do the lookup with
      # @param [Ruote::Workitem] workitem The workitem to store
      # @return [true, false] True if there was a previous workitem
      #   with the same key, false otherwise
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

      # Deletes a previously stored key from storage
      # @param [#to_s] key The key to delere
      # @return [void]
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
