module OpenStack
  module Heat
    class Stack

      attr_reader :id
      attr_reader :creation_time
      attr_reader :description
      attr_reader :link
      attr_reader :name
      attr_reader :status
      attr_reader :status_reason
      attr_reader :updated_time
      attr_reader :tags

      class << self
        #require params:  {:display_name, :size}
        #optional params: {:display_description, :metadata=>{:key=>val, ...}, :availability_zone, :stack_type }
        #returns OpenStack::Volume::Volume object
        def create data
          heat_conn = OpenStack::Heat::Connection.heat_conn
          # raise OpenStack::Exception::MissingArgument, ":display_name and :size must be specified to create a stack" unless (options[:display_name] && options[:size])

          response = heat_conn.csreq "POST",
                                       heat_conn.service_host,
                                       "/stacks",
                                       heat_conn.service_port,
                                       heat_conn.service_scheme,
                                       {'content-type' => 'application/json'},
                                       JSON.generate(data.merge :tenant_id => heat_conn.tenant_id)

          OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
          stack_info = JSON.parse(response.body)["stack"]
          stack = OpenStack::Heat::Stack.new(stack_info, heat_conn)
        end

        #no options documented in API at Nov 2012
        #(e.g. like limit/marker as used in Nova for servers)
        def stacks
          response = OpenStack::Heat::Connection.heat_conn.req('GET', '/stacks')
          stacks_hash = JSON.parse(response.body)["stacks"]
          stacks_hash.inject([]){|res, current| res << OpenStack::Heat::Stack.new(current); res}
        end

        def find stack_id
          response = OpenStack::Heat::Connection.heat_conn.req("GET", "/#{stack_id}")
          stack_hash = JSON.parse(response.body)["stack"]
          OpenStack::Heat::Stack.new(stack_hash, heat_conn)
        end
        alias :stack :find
      end

      def initialize(stack_info)
        @heat_conn     = OpenStack::Heat::Connection.heat_conn
        @id            = stack_info['id']
        @creation_time = stack_info['creation_time']
        @description   = stack_info['description']
        @link          = stack_info['links'].detect{ |link| link['rel'] == 'self' }['href'].split(@heat_conn.service_path).last
        @name          = stack_info['stack_name']
        @status        = stack_info['stack_status']
        @status_reason = stack_info['stack_status_reason']
        @updated_time  = stack_info['updated_time']
        @tags          = stack_info['tags']
        @stack_info    = stack_info
      end

      def delete
        response = @heat_conn.req("DELETE", "/#{@heat_conn.service_path}/#{stack_id}")
        true
      end

      def details
        return @details if @details
        response = @heat_conn.req 'GET', @link
        OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
        @details = JSON.parse(response.body)["stack"]
      end

      def outputs
        details['outputs']
      end

      def parameters
        Hash[details['parameters'].map {|k, v| [k.gsub('OS::',''), v] }]
      end

      def resources
        response = @heat_conn.req 'GET', "#{@link}/resources"
        OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
        JSON.parse(response.body)["resources"]
      end

      def template
        response = @heat_conn.req 'GET', "#{@link}/template"
        OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
        JSON.parse(response.body)
      end

    end
  end
end
