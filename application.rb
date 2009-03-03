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

get '/tos.html' do
  haml :tos
end

get '/:id' do
  @stubble = Stubble.get!(params[:id])
  @stubble.count!
  redirect @stubble.url.to_s
end

get '/:id.html' do
  @stubble = Stubble.get!(params[:id])
  haml :show
end

post '/' do
  if request.env['HTTP_USER_AGENT'] =~ /MSIE/
    haml :oops
  else
    attrs = {:url => params[:url], :created_from => request.env['REMOTE_ADDR']}
    @stubble = Stubble.new(attrs)
    if @stubble.save
      redirect stubble_url(@stubble, :html)
    else
      haml :fail
    end
  end
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
    CGI::escapeHTML(text.to_s)
  end
  
  def wrap(text, length = 72)
    text.to_s.scan(/.{1,#{length}}/).map {|s| h(s) }.join('<br />')
  end
  
  def truncate(text, length = 30)
    text.to_s.length <= length ? text.to_s : "#{text.to_s[0,length]}..."
  end
  
  def numerify(n)
    (n || 0).to_s.reverse.scan(/\d{1,3}/).join(',').reverse
  end
  
  def stubble_path(stubble, format = nil)
    path = "/#{stubble.id}"
    [path, format].compact.join('.')
  end
  
  def stubble_url(stubble, format = nil)
    path = stubble_path(stubble, format)
    
    case ENV['RACK_ENV']
    when 'production'
      # "http://stubb.ly#{path}"
      "http://s.urgetopunt.com#{path}"
    when 'test'
      "http://test.host#{path}"
    else
      "http://stubbly.local#{path}"
    end
  end
end
