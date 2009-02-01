require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => ENV['RACK_ENV'],
  :views => File.join(File.dirname(__FILE__), 'views')
)

require 'stubbly'
run Sinatra.application
