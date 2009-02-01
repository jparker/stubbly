require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'

# TODO:
# - don't create stubble if one exists with given url (return existing)
# - implement custom hash generator (max radix for String#to_i is 36)

class Stubble
  include DataMapper::Resource
  
  property :id, Serial
  property :url, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :view_count, Integer, :default => 0

  def increment!
    update_attributes(:view_count => view_count + 1)
  end
end

case ENV['RACK_ENV']
when 'development', 'test'
  DataMapper.setup(:default, 'sqlite3::memory')
  DataMapper.auto_migrate!
else
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.db")
end
