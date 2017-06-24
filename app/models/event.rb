class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  embedded_in :parent, polymorphic: true, touch: true

  validates_presence_of :order, :name

  #returns length of course in meters
  def meters
  	#byebug
  	case units
	  	when "meters" then distance
	  	when "kilometers" then distance*1000
	  	when "yards" then distance*0.9144
	  	when "miles" then distance*1609.344
	  	else nil
  	end
  end

  #returns length of course in miles
  def miles
  	#byebug
  	case units
	  	when "miles" then distance
	  	when "yards" then distance*0.000568182
	  	when "meters" then distance*0.000621371
	  	when "kilometers" then distance*0.621371
	  	else nil
  	end
  end
end
