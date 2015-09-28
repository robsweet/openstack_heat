module OpenStack
  module Heat
    class Stack

    attr_reader :id
    attr_reader :display_name
    attr_reader :display_description
    attr_reader :size
    attr_reader :stack_type
    attr_reader :metadata
    attr_reader :availability_zone
    attr_reader :snapshot_id
    attr_reader :attachments
    attr_reader :created_at
    attr_reader :status

    #require params:  {:display_name, :size}
    #optional params: {:display_description, :metadata=>{:key=>val, ...}, :availability_zone, :stack_type }
    #returns OpenStack::Volume::Volume object
    def self.create options
      # raise OpenStack::Exception::MissingArgument, ":display_name and :size must be specified to create a stack" unless (options[:display_name] && options[:size])
      data = JSON.generate :stack => options
      response = @connection.csreq "POST",
                                   @connection.service_host,
                                   "#{@connection.service_path}/#{@stack_path}",
                                   @connection.service_port,
                                   @connection.service_scheme,
                                   {'content-type' => 'application/json'},
                                   data

      OpenStack::Exception.raise_exception(response) unless response.code.match(/^20.$/)
      stack_info = JSON.parse(response.body)["stack"]
      stack = OpenStack::Heat::Stack.new(stack_info)
    end

    #no options documented in API at Nov 2012
    #(e.g. like limit/marker as used in Nova for servers)
    def self.stacks
      response = @connection.req("GET", "/#{@stack_path}")
      stacks_hash = JSON.parse(response.body)["stacks"]
      stacks_hash.inject([]){|res, current| res << OpenStack::Heat::Stack.new(current); res}
    end
    alias :stacks :list_stacks

    def self.find(stack_id)
      response = @connection.req("GET", "/#{@stack_path}/#{stack_id}")
      stack_hash = JSON.parse(response.body)["stack"]
      OpenStack::Volume::Volume.new(stack_hash, @connection)
    end
    alias :stack :find

    def initialize(stack_info, connection)
      @conn                = connection
      @id                  = stack_info['id']
      @creation_time       = stack_info['creation_time']
      @description         = stack_info['description']
      @link                = stack_info['links']['href']
      @stack_name          = stack_info['stack_name']
      @stack_status        = stack_info['stack_status']
      @stack_status_reason = stack_info['stack_status_reason']
      @updated_time        = stack_info['updated_time']
      @tags                = stack_info['tags']
    end

    def suspend

    end

    def resume
    end

    def cancel
    end

    def resources
    end

    def delete
      response = @conn.req("DELETE", "/#{@stack_path}/#{stack_id}")
      true
    end

  end
end
