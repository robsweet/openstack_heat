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

    #require params:  {:display_name, :size}
    #optional params: {:display_description, :metadata=>{:key=>val, ...}, :availability_zone, :stack_type }
    #returns OpenStack::Volume::Volume object
    def create_stack(options)
      # raise OpenStack::Exception::MissingArgument, ":display_name and :size must be specified to create a stack" unless (options[:display_name] && options[:size])
      data = JSON.generate(:stack => options)
      response = @connection.csreq("POST",@connection.service_host,"#{@connection.service_path}/#{@stack_path}",@connection.service_port,@connection.service_scheme,{'content-type' => 'application/json'},data)
      OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
      stack_info = JSON.parse(response.body)["stack"]
      stack = OpenStack::Volume::Volume.new(stack_info)
    end

    #no options documented in API at Nov 2012
    #(e.g. like limit/marker as used in Nova for servers)
    def list_stacks
      response = @connection.req("GET", "/#{@stack_path}")
      stacks_hash = JSON.parse(response.body)["stacks"]
      stacks_hash.inject([]){|res, current| res << OpenStack::Heat::Stack.new(current); res}
    end
    alias :stacks :list_stacks


    def get_stack(stack_id)
      response = @connection.req("GET", "/#{@stack_path}/#{stack_id}")
      stack_hash = JSON.parse(response.body)["stack"]
      OpenStack::Volume::Volume.new(stack_hash, @connection)
    end
    alias :stack :get_stack

    def delete_stack(stack_id)
      get_stack(stack_id).delete
    end

    private




  end

end
end
