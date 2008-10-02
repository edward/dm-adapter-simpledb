require 'rubygems'
require 'dm-core'
require 'aws_sdb'
require 'digest/sha1'

module DataMapper
  module Adapters
    class SimpleDBAdapter < AbstractAdapter

      def create(resources)
        created = 0
        resources.each do |resource|
          simpledb_type = simpledb_type(resource.model)
          attributes    = resource.attributes.merge(:simpledb_type => simpledb_type)
          
          item_name = "#{simpledb_type}+"
          keys = resource.model.key(self.name).sort {|a,b| a.name.to_s <=> b.name.to_s}
          item_name += keys.map do |property|
            resource.instance_variable_get(property.instance_variable_name)
          end.join('-')
          item_name = Digest::SHA1.hexdigest(item_name)

          sdb.put_attributes(domain, item_name, attributes)
          
          created += 1
        end
        created
      end
      
      def delete(query)
        deleted = 0
        simpledb_type = simpledb_type(query.model)
        
        item_name = "#{simpledb_type}+"
        keys = query.model.key(self.name).sort {|a,b| a.name.to_s <=> b.name.to_s }
        conditions = query.conditions.sort {|a,b| a[1].name.to_s <=> b[1].name.to_s }
        item_name += conditions.map do |property|
          property[2].to_s
        end.join('-')
        item_name = Digest::SHA1.hexdigest(item_name)

        sdb.delete_attributes(domain, item_name)
        
        deleted += 1
        
        # Curosity check to make sure we are only dealing with a delete
        conditions = conditions.map {|c| c[0] }.uniq
        operators = [ :gt, :gte, :lt, :lte, :not, :like, :in ]
        raise NotImplementedError.new('Only :eql on delete at the moment') if (operators - conditions).size != operators.size
        
        deleted
      end
      
      def read_many(query)
        simpledb_type = simpledb_type(query.model)
        
        conditions = ["['simpledb_type' = '#{simpledb_type}']"]
        if query.conditions.size > 0
          conditions += query.conditions.map do |condition|
            operator = case condition[0]
              when :eql then '='
              when :not then '!='
              when :gt  then '>'
              when :gte then '>='
              when :lt  then '<'
              when :lte then '<='
              else raise "Invalid query operator: #{operator.inspect}"
            end
            "['#{condition[1].name.to_s}' #{operator} '#{condition[2].to_s}']"
          end
        end
        
        results = sdb.query(domain, conditions.compact.join(' intersection '))
        results = results[0].map {|d| sdb.get_attributes(domain, d) }
        
        Collection.new(query) do |collection|
          results.each do |result|
            data = query.fields.map do |property|
              value = result[property.field.to_s]
              if value.size > 1
                value.map {|v| property.typecast(v) }
              else
                property.typecast(value[0])
              end
            end
            collection.load(data)
          end
        end
      end
      
      def read_one(query)
        simpledb_type = simpledb_type(query.model)
        
        item_name = "#{simpledb_type}+"
        keys = query.model.key(self.name).sort {|a,b| a.name.to_s <=> b.name.to_s }
        conditions = query.conditions.sort {|a,b| a[1].name.to_s <=> b[1].name.to_s }
        item_name += conditions.map do |property|
          property[2].to_s
        end.join('-')
        item_name = Digest::SHA1.hexdigest(item_name)

        data = sdb.get_attributes(domain, item_name)       
        unless data.empty?
          data = query.fields.map do |property|
            value = data[property.field.to_s]
            if value.size > 1
              value.map {|v| property.typecast(v) }
            else
              property.typecast(value[0])
            end
          end
          
          query.model.load(data, query)
        end
      end

      def update(attributes, query)
        updated = 0
        
        simpledb_type = simpledb_type(query.model)
        
        item_name = "#{simpledb_type}+"
        keys = query.model.key(self.name).sort {|a,b| a.name.to_s <=> b.name.to_s }
        conditions = query.conditions.sort {|a,b| a[1].name.to_s <=> b[1].name.to_s }
        item_name += conditions.map do |property|
          property[2].to_s
        end.join('-')
        item_name = Digest::SHA1.hexdigest(item_name)

        attributes = attributes.to_a.map {|a| [a.first.name.to_s, a.last]}.to_hash
        sdb.put_attributes(domain, item_name, attributes, true)
        
        updated += 1
        
        # Curosity check to make sure we are only dealing with a delete
        conditions = conditions.map {|c| c[0] }.uniq
        selectors = [ :gt, :gte, :lt, :lte, :not, :like, :in ]
        raise NotImplementedError.new('Only :eql on delete at the moment') if (selectors - conditions).size != selectors.size
        
        updated
      end
    private
      
      def domain
        @uri[:domain]
      end
      
      def sdb
        @sdb ||= AwsSdb::Service.new(:access_key_id => @uri[:access_key], :secret_access_key => @uri [:secret_key])
        @sdb
      end
      
      def simpledb_type(model)
        model.storage_name(model.repository.name)
      end
      
    end # class SimpleDBAdapter
    
    # Required naming scheme.
    SimpledbAdapter = SimpleDBAdapter
    
  end # module Adapters
end # module DataMapper