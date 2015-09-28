require 'rubygems'
require './lib/openstack/heat.rb'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "openstack_heat"
    gemspec.summary = "OpenStack Heat Ruby API"
    gemspec.description = "API Binding for OpenStack"
    gemspec.email = ["rob@ldg.net"]
    gemspec.homepage = "https://github.com/robsweet/ruby-openstack_heat"
    gemspec.authors = ["Rob Sweet"]
    gemspec.add_dependency 'json'
    gemspec.add_dependency 'openstack'
    gemspec.files = Dir.glob('lib/**/*.rb')
    gemspec.files << "README.rdoc"
    gemspec.files << "VERSION"
    gemspec.files << "COPYING"
    (gemspec.files << Dir.glob("test/*.rb")).flatten!
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end
Rake::Task['test'].comment = "Unit"
