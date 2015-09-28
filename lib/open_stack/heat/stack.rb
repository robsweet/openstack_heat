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
