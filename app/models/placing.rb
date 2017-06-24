#a custom type called Placing to handle processing the placing format within the ingested JSON data.

class Placing

#name is a string mapped to document key of name and place is an integer mapped to the document key of place
attr_accessor :name, :place


#name is the category name and place is the ordinal placeing
def initialize(name, place)
	@name = name
	@place = place
end

#Creates db form of instance - marshals the state of the instance into MongoDB format as a Ruby hash.
def mongoize
	{:name=>@name, :place=>@place}
end


#implement a class method called mongoize that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash – and returns the state marshalled into MongoDB format as a Ruby hash (if
#appropriate).
def self.mongoize object
	case object
		when Hash then Placing.new(object[:name],object[:place]).mongoize
		when Placing then object.mongoize
		else object #for nil passed in
	end
end

#implement a class that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash form – and returns an instance of the class (if appropriate).
def self.demongoize object
	#byebug
	case object
		when Hash then Placing.new(object[:name],object[:place])
		when Placing then Placing #already instance of class
		else object #when nil
	end
end

#implement a class method called evolve that functionally behaves the same as the mongoize class method
def self.evolve(object)
	case object
    	when Placing then object.mongoize
    	else object
	end
end


end