module OpenStack
  module Heat
    class Connection < OpenStack::Connection

      def self.create options = {:retry_auth => true}
        @@heat_conn = new options
      end

      def self.heat_conn
        @@heat_conn
      end

      attr_reader :tenant_id
      attr_reader :service_uri
      attr_reader :service_type

      def initialize options
        options.merge! :service_name => 'heat', :service_type => 'orchestration'
        super
        OpenStack::Authentication.init self
      end

      # Returns true if the authentication was successful and returns false otherwise.
      #
      #   cs.authok?
      #   => true
      def authok?
        authok
      end

    end

  end
end
