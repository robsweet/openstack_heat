#!/usr/bin/env ruby
#
# == Ruby OpenStack Heat API
#
# See COPYING for license information.
# ----
#
# === Documentation & Examples
# To begin reviewing the available methods and examples, view the README.rdoc file
#
# Example:
# os = OpenStack::Connection.create({:username => "herp@derp.com", :api_key=>"password",
#               :auth_url => "https://region-a.geo-1.identity.cloudsvc.com:35357/v2.0/",
#               :authtenant=>"herp@derp.com-default-tenant", :service_type=>"object-store")
#
# will return a handle to the object-storage service swift. Alternatively, passing
# :service_type=>"compute" will return a handle to the compute service nova.

module OpenStack::Heat
  require 'rubygems'
  require 'net/http'
  require 'net/https'
  require 'openstack'
  require 'uri'
  require 'json'
  require 'date'

  unless "".respond_to? :each_char
    require "jcode"
    $KCODE = 'u'
  end

  $:.unshift(File.dirname(__FILE__))
  Dir.glob( File.dirname(__FILE__) + '/heat/*', &method(:require))

end

