require 'pathname'
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/simpledb_adapter'

access_key = ENV['AMAZON_ACCESS_KEY_ID']
secret_key = ENV['AMAZON_SECRET_ACCESS_KEY']

DataMapper.setup(:default, {
  :adapter => 'simpledb',
  :access_key => access_key,
  :secret_key => secret_key,
  :domain => 'missionaries'
})

class Person
  include DataMapper::Resource
  
  property :id,         String, :key => true
  property :name,       String, :key => true
  property :age,        Integer
  property :wealth,     Float
  property :birthday,   Date
  property :created_at, DateTime
  
  belongs_to :company
end

class Company
  include DataMapper::Resource
  
  property :id,   String, :key => true
  property :name, String, :key => true
  
  has n, :people
end