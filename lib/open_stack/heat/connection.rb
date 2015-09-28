module OpenStack
  module HeatCfn
    class Connection

      attr_accessor   :connection
      attr_reader     :stacks

      def initialize(connection)
        @connection = connection
        OpenStack::Authentication.init(@connection)
        @stack_path = "#{@connection.authtenant_name}/stacks"
      end

      # Returns true if the authentication was successful and returns false otherwise.
      #
      #   cs.authok?
      #   => true
      def authok?
        @connection.authok
      end








      def delete_stack(stack_id)
        get_stack(stack_id).delete
      end

      private




    end

  end
end
