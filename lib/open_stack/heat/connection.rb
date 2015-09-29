module OpenStack
  module Heat
    class Connection < OpenStack::Connection

      def self.create options = {:retry_auth => true}
        @@heat_conn ||= new options
      end

      def self.heat_conn
        @@heat_conn
      end

      def initialize options
        options.merge! :service_name => 'heat', :service_type => 'orchestration'
        super
        OpenStack::Authentication.init self
      end

      def tenant_id
        @tenant_id ||= service_path.split('/').last
      end

    end
  end
end
