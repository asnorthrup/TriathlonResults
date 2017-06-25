#act as the root-level document in the races collection ingested in the initial section

class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address

  #relationship with events, relationship is polymophic type as parent, default ascending sort based on order field
  embeds_many :events, as: :parent, order: [:order.asc]
  #reference the _id document field property within the embedded RaceRef stored using the race field
  has_many :entrants, foreign_key: "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  #named scopes for finding races current and future
  scope :past, ->{where(:date.lt=>Date.current)}
  scope :upcoming, ->{where(:date.gte=>Date.current)}

  #create a default events hash for setting up initial values for a default configuration
  DEFAULT_EVENTS = {"swim"=>{:order=>0, :name=>"swim", :distance=>1.0, :units=>"miles"},
                    "t1"=> {:order=>1,:name=>"t1"},
                    "bike"=>{:order=>2,:name=>"bike", :distance=>25.0, :units=>"miles"},
                    "t2"=> {:order=>3,:name=>"t2"},
                    "run"=> {:order=>4,:name=>"run", :distance=>10.0, :units=>"kilometers"}}

#metadataprogramming definition: out loop driver by keys of DEFAULT_EVENT hash and defines implementation
#for getting and/or creating event. inner loop conditionally creates getter/setter for lower level property
#if value exists in hash
DEFAULT_EVENTS.keys.each do |name|
  define_method("#{name}") do
    event=events.select {|event| name==event.name}.first
    event||=events.build(DEFAULT_EVENTS["#{name}"])
  end
  ["order","distance","units"].each do |prop|
    if DEFAULT_EVENTS["#{name}"][prop.to_sym]
      define_method("#{name}_#{prop}") do
        event=self.send("#{name}").send("#{prop}")
      end
      define_method("#{name}_#{prop}=") do |value|
        event=self.send("#{name}").send("#{prop}=", value)
      end
    end
  end
end

#implement a default instance of the Race
def self.default
  Race.new do |race|
    DEFAULT_EVENTS.keys.each {|leg|race.send("#{leg}")}
  end
end

#provided flattened access to city and state within Race.location
["city", "state"].each do |action|
  define_method("#{action}") do
    self.location ? self.location.send("#{action}") : nil
  end
  define_method("#{action}=") do |name|
    object=self.location ||= Address.new
    object.send("#{action}=", name)
    self.location=object
  end
end

end
