require 'rubygems'
require 'cgi'
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
end

get '/:slug.html' do
  @stubble = Stubble.get_by_slug!(params[:slug])
  haml :show
end

post '/' do
  @stubble = Stubble.new(:url => params[:url])
  @stubble.save
  redirect "/#{@stubble.slug}.html"
end

helpers do
  def stylesheet_tag(path, options = {})
    options.merge!(:rel => 'stylesheet', :type => 'text/css', :href => path)
    options[:media] ||= 'screen,projection'
    %Q{<link #{options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')} />}
  end
  
  def link_to(text, url, options = {})
    options.merge!(:href => h(url))
    %Q{<a #{options.map {|k,v| %Q{#{k}="#{v}"} }.join(' ')}>#{text}</a>}
  end
  
  def h(text)
    CGI::escapeHTML(text)
  end
  
  def truncate(text, length = 30)
    text.length <= length ? text : "#{text[0,length]}..."
  end
  
  def wrap(text, length = 72)
    text.scan(/.{1,length}/).join('&nbsp;')
  end
end
