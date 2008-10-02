require 'pathname'
require Pathname(__FILE__).dirname.expand_path + 'spec_helper'

describe DataMapper::Adapters::SimpleDBAdapter do
  before(:each) do
    @person_attrs = { :id => "person-#{Time.now.to_f.to_s}", :name => 'Jeremy Boles', :age  => 25, 
                      :wealth => 25.00, :birthday => Date.today }
    @person = Person.new(@person_attrs)
  end
  
  it 'should create a record' do
    @person.save.should be_true
    @person.id.should_not be_nil
    @person.destroy
  end
  
  describe 'with a saved record' do
    before(:each) { @person.save }
    after(:each)  { @person.destroy }
    
    it 'should get a record' do
      person = Person.get!(@person.id, @person.name)
      person.should_not be_nil
      person.wealth.should == @person.wealth
    end
     
    it 'should not get records of the wrong type by id' do
      Company.get(@person.id, @person.name).should == nil
      lambda { Company.get!(@person.id, @person.name) }.should raise_error(DataMapper::ObjectNotFoundError)
    end
     
    it 'should update a record' do
      person = Person.get!(@person.id, @person.name)
      person.wealth = 100.00
      person.save
      
      person = Person.get!(@person.id, @person.name)
      person.wealth.should_not == @person.wealth
      person.age.should == @person.age
      person.id.should == @person.id
      person.name.should == @person.name
    end
     
    it 'should destroy a record' do
      @person.destroy.should be_true
    end
   
  end
   
  describe 'with multiple records saved' do
    before(:each) do
      @jeremy   = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Jeremy Boles", :age => 25))
      @danielle = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Danille Boles", :age => 26))
      @keegan   = Person.create(@person_attrs.merge(:id => Time.now.to_f.to_s, :name => "Keegan Jones", :age => 20))
    end
     
    after(:each) do
      @jeremy.destroy
      @danielle.destroy
      @keegan.destroy
    end
     
    it 'should get all records' do
      Person.all.length.should == 3
    end
    
    it 'should get records by eql matcher' do
      people = Person.all(:age => 25)
      people.length.should == 1
    end
    
    it 'should get records by not matcher' do
      people = Person.all(:age.not => 25)
      people.length.should == 2
    end
    
    it 'should get records by gt matcher' do
      people = Person.all(:age.gt => 25)
      people.length.should == 1
    end
    
    it 'should get records by gte matcher' do
      people = Person.all(:age.gte => 25)
      people.length.should == 2
    end
    
    it 'should get records by lt matcher' do
      people = Person.all(:age.lt => 25)
      people.length.should == 1
    end
    
    it 'should get records by lte matcher' do
      people = Person.all(:age.lte => 25)
      people.length.should == 2
    end
    
    it 'should get records with multiple matchers' do
      people = Person.all(:birthday => Date.today, :age.lte => 25)
      people.length.should == 2
    end
    
    it 'should handle DateTime' do
      pending 'Need to figure out how to coerce DateTime'
      time = Time.now
      @jeremy.created_at = time
      @jeremy.save
      person = Person.get!(@jeremy.id, @jeremy.name)
      person.created_at.should == time
    end
    
    it 'should handle Date' do
      person = Person.get!(@jeremy.id, @jeremy.name)
      person.birthday.should == @jeremy.birthday
    end

    it 'should order records'
    it 'should get records by the like matcher'   
   end
   
    
   describe 'associations' do
     it 'should work with belongs_to associations'
     it 'should work with has n associations'
   end
   
   describe 'STI' do
     it 'should override default type'
     it 'should load descendents on parent.all' 
     it 'should raise an error if you have a column named couchdb_type'
   end
end