require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'core_ext'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.db")
DataMapper.auto_migrate!

# TODO:
# - don't create stubble if one exists with given url (return existing)
# - implement custom hash generator (max radix for String#to_i is 36)

class Stubble
  include DataMapper::Resource
  
  property :id, Serial
  property :url, String, :length => 2048
  property :created_at, DateTime
  property :updated_at, DateTime
  property :view_count, Integer, :default => 0
  
  def increment!
    update_attributes(:view_count => view_count + 1)
  end
  
  def self.recent(limit = 10)
    all(:order => [:created_at.desc], :limit => limit)
  end
  
  def self.get_by_slug!(slug)
    get!(slug.to_base10)
  end
  
  def slug
    id.to_base64
  end
end
