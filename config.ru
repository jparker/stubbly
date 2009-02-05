require 'rubygems'
require 'sinatra'

Sinatra::Application.set(:run, false)
Sinatra::Application.set(:environment, ENV['RACK_ENV'])
Sinatra::Application.set(:views, File.join(File.dirname(__FILE__), 'views'))

require 'application'
run Sinatra::Application
