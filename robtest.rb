#!/Users/rsweet/.rbenv/shims/ruby

require 'pp'
require 'net/http'

module Net
  class HTTP
    alias_method '__initialize__', 'initialize'

    def initialize(*args,&block)
      __initialize__(*args, &block)
    ensure
      @debug_output = $stderr ### if ENV['HTTP_DEBUG']
    end
  end
end

require './lib/open_stack/heat'

OpenStack::Heat::Connection.create  :username    => "admin",
                                    :api_key     => "osnodeCL3100",
                                    :auth_url    => "http://10.201.10.12:35357/v2.0/",
                                    :authtenant  => "demo"

stacks = OpenStack::Heat::Stack.stacks
binding.pry