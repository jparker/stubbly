require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
require 'core_ext'

DataMapper.setup(:default, "mysql://stubbly:awooga@localhost/stubbly_#{ENV['RACK_ENV']}")
DataMapper.auto_migrate!

# TODO:
# - don't create stubble if one exists with given url (return existing)
# - implement custom hash generator (max radix for String#to_i is 36)

class Stubble
  include DataMapper::Resource
  
  property :id, Serial
  property :url, URI, :length => 2048
  property :created_from, IPAddress
  property :created_at, DateTime
  property :updated_at, DateTime
  property :view_count, Integer, :default => 0
  
  before :valid?, :prepend_default_uri_scheme
  
  validates_with_method :url, :method => :valid_uri_scheme
  validates_with_method :url, :method => :valid_uri_length
  validates_with_method :url, :method => :valid_uri_host
  
  def self.recent(limit = 10)
    all(:order => [:created_at.desc], :limit => limit)
  end
  
  def count!
    update_attributes(:view_count => view_count + 1)
  end
  
  def self.get(id)
    id.is_a?(String) ? super(id.to_base10) : super(id)
  end
  
  def self.get!(id)
    id.is_a?(String) ? super(id.to_base10) : super(id)
  end
  
  def id
    attribute_get(:id).to_base64 rescue nil
  end
  
  def id=(id)
    attribute_set(:id, id.to_s.to_base10)
  end
  
  def stub_path(format = nil)
    [id, format].compact.join('.')
  end
  
  def stub_url(base = 'http://s.urgetopunt.com/')
    "#{base}#{stub_path}"
  end
  
  def stubbliness
    (100 - 100.0 * stub_url.size / url.to_s.size)
  end
  
  private
  def prepend_default_uri_scheme
    url.scheme ||= 'http'
  end
  
  def valid_uri_scheme
    return true if %w[http https].include?(url.scheme)
    [false, 'Only "http" and "https" URIs are allowed']
  end
  
  def valid_uri_length
    return true if url.to_s.length <= 2048
    [false, "URI is too long (2048 characters max)"]
  end
  
  def valid_uri_host
    return true unless url.host =~ %r{
      \A .* (?:
        stubbly\.local    |
        stubb\.ly         |
        s.urgetopunt\.com |
        tinyurl\.com      |
        rubyurl\.com      |
        bit\.ly           |
        is\.gd            |
        localhost
      ) \Z
    }x
    [false, "URI host #{url.host.inspect} not allowed"]
  end
end
