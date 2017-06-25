#Implement a custom type called Point to handle processing the GeoJSON Point format within the ingested JSON
#data
class Point

#read/write acess to lat and long fields
attr_accessor :longitude, :latitude


def initialize(lng,lat)
	@longitude = lng
	@latitude = lat
end


#Creates db form of instance - marshals the state of the instance into MongoDB format as a Ruby hash.
def mongoize
	{:type=>"Point", :coordinates=>[@longitude,@latitude]}
end

#implement a class method called mongoize that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash – and returns the state marshalled into MongoDB format as a Ruby hash (if
#appropriate).
def self.mongoize object
	case object
		when Hash then
			if object[:type] #in GeoJSON Point format
				Point.new(object[:coordinates][0],object[:coordinates][1]).mongoize
			else #in legacy format
				Point.new(object[:lng],object[:lat]).mongoize
			end
		when Point then object.mongoize

		else object #for nil passed in
	end
end

#implement a class that accepts a single argument of at least three (3) forms – nil,
#class instance, and database hash form – and returns an instance of the class (if appropriate).
def self.demongoize object
	case object
		when Hash then 
			if object[:type] #geoJSON Point format
				Point.new(object[:coordinates][0],object[:coordinates][1])
			else
				Point.new(object[:lng], object[:lat])
			end
		when Point then Point #already instance of class
		else object #when nil
	end
end

#implement a class method called evolve that functionally behaves the same as the mongoize class method
def self.evolve(object)
	case object
    	when Point then object.mongoize
    	else object
	end
end


end