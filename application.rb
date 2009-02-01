require 'rubygems'
require 'sinatra'
require 'stubble'

enable :sessions

error DataMapper::ObjectNotFoundError do
  "Wowzers: #{request.env['sinatra.error']}"
end

before do
  @stubbles = Stubble.recent(15)
end

# TODO:
# - list of most popular stubbles on main page

get '/' do
  haml :index
end

get '/about.html' do
  haml :about
end

get '/:slug' do
  @stubble = Stubble.get_by_slug!(params[:slug])
  @stubble.url
  # redirect @stubble.url
end

post '/' do
  @stubble = Stubble.new(:url => params[:url])
  @stubble.save
  haml :show
end

helpers do
  def stylesheet_tag(path, options = {})
    options.merge!(:rel => 'stylesheet', :type => 'text/css', :href => path)
    options[:media] ||= 'screen,projection'
    %Q{<link #{options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')} />}
  end
  
  def link_to(text, url, options = {})
    options.merge!(:href => url)
    %Q{<a #{options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')}>#{text}</a>}
  end
  
  def truncate(text, length = 30)
    text.length <= length ? text : "#{text[0,length]}&hellip;"
  end
  
  def flash
    session[:flash] ||= Flash.new
  end
end
