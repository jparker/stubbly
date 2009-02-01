require 'rubygems'
require 'sinatra'
require 'stubble'

before do
  hsh = {}
  request.params.each do |key, value|
    this = hsh
    keys = key.split(/\]\[|\]|\[/)
    keys.each_index do |i|
      break if keys.length == i + 1
      this[keys[i]] ||= {}
      this = this[keys[i]]
    end
    this[keys[-1]] = value
  end
  request.params.replace hsh
end

# TODO:
# - list of recent stubbles on main page
# - list of most popular stubbles on main page

# Front page
get '/' do
  haml :index
end

# Lookup existing stubbly url
get '/*' do
  @stubble = Stubble.get!(params['splat'][0].to_i(36))
  haml :show
end

# Create new stubbly url
post '/' do
  @stubble = Stubble.new(params[:stubble])
  if @stubble.save
    redirect '/'
  else
    haml :index
  end
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
end
