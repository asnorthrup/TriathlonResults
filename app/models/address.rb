#Implement a custom type called handle processing the address format within the ingested JSON data
class Address

#read/write acess to city a string, state a string, location a point
attr_accessor :city, :state, :location


def initialize(city=nil, state=nil, location=nil)
	@city = city
	@state = state
	@location = location
end



#Creates db form of instance - marshals the state of the instance into MongoDB format as a Ruby hash.
def mongoize
	{:city=>@city, :state=>@state, :loc=>@location.mongoize}
end


#implement a class method called mongoize that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash – and returns the state marshalled into MongoDB format as a Ruby hash (if
#appropriate).
def self.mongoize object
	case object
		when Hash then Address.new(object[:city],object[:state],object[:loc]).mongoize
		when Address then object.mongoize
		else object #for nil passed in
	end
end

#implement a class that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash form – and returns an instance of the class (if appropriate).
def self.demongoize object
	#byebug
	case object
		#getting error when :loc is nil
		when Hash then 
			if object[:loc].nil?
				Address.new(object[:city],object[:state], nil) #just pass in nils for lat/long
			else
				Address.new(object[:city],object[:state],Point.new(object[:loc][:coordinates][0],object[:loc][:coordinates][1]))
			end
		when Address then Address #already instance of class
		else object #when nil
	end
end

#implement a class method called evolve that functionally behaves the same as the mongoize class method
def self.evolve(object)
	case object
    	when Address then object.mongoize
    	else object
	end
end


end