require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-types'
require 'dm-validations'
require 'extlib'
require 'core_ext'

DataMapper.setup(:default, "mysql://stubbly:awooga@localhost/stubbly_#{ENV['RACK_ENV']}")
DataMapper.auto_migrate!

# TODO:
# - don't create stubble if one exists with given url (return existing)

class Stubble
  include DataMapper::Resource
  
  @@blacklist = %r{\A .* (?:
      stubbly\.local      |
      stubb\.ly           |
      s\.urgetopunt\.com  |
      tinyurl\.com        |
      rubyurl\.com        |
      bit\.ly             |
      is\.gd              |
      localhost           |
      127\.0\.0\.1
    ) \Z
  }x
  
  property :id, Serial
  property :url, URI, :length => 2048, :nullable => false
  property :created_from, IPAddress
  property :created_at, DateTime
  property :updated_at, DateTime
  property :view_count, Integer, :default => 0
  
  validates_with_method :url, :method => :uri_is_valid?
  
  def self.recent(limit = 10)
    all(:order => [:created_at.desc], :limit => limit)
  end
  
  def count!
    update_attributes(:view_count => view_count + 1)
  end
  
  def self.get(id)
    id.is_a?(String) ? super(id.from_base(64)) : super(id)
  end
  
  def id
    attribute_get(:id).to_base(64) rescue nil
  end
  
  def id=(id)
    attribute_set(:id, id.to_s.from_base(64))
  end
  
  def stubbliness
    (100 - 100.0 * "/#{id}".size / [url.path, url.query].compact.join('?').size)
  end
  
  private
  def uri_is_valid?
    messages = []
    
    unless url.nil?
      if url.to_s.length > 2048
        messages << 'URI is too long (2,048 characters max)'
      end
      
      unless %w[http https].include?(url.scheme)
        messages << 'URI scheme must be "http" or "https"'
      end
      
      if url.host =~ @@blacklist
        messages << "URI host #{url.host.inspect} is not allowed"
      end
    end
    
    messages.empty? ? true : [false, messages]
  end
end
