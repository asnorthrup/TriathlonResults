#act as the root-level document in the races collection ingested in the initial section

class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address
  field :next_bib, type: Integer, default: 0

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

#override the getter for next_bit to perform atomic increment of next_bib value in the database
#and return the result of next_bib. 
def next_bib
  #don't use next_bib to access use [:next_bib] as this would be a infinite recursive back into this method
  self.inc(next_bib:1)
  self[:next_bib]
end

#instance method that returns a Placing instance with its name set to name of the age group the racer
#will be compting in
def get_group racer
  if racer && racer.birth_year && racer.gender
    #determin age as of Jan 1 on year of race; put racer in group rounded down to nearest 10 and up
    #to nearest9s; masters is 60+
    quotient=(date.year-racer.birth_year)/10
    min_age=quotient*10
    max_age=((quotient+1)*10)-1
    gender=racer.gender
    name=min_age >= 60 ? "masters #{gender}" : "#{min_age} to #{max_age} (#{gender})" #text format of groups
    Placing.demongoize(:name=>name)
  end
end

#instance method that creates a new Entrant for the Race for a supplied Racer. Method will update the races and
#results collection. races will have the next_bib number of a Race document updated and results will have
#a new Entrant document inserted with information cloned from both Race and Racer
def create_entrant(racer)
  #byebug
  e=Entrant.new
  #next line not correct
  e.build_race(self.attributes.symbolize_keys.slice(:_id, :n, :date)) #clone(create new instance) race information within Entrant.race
  e.build_racer(racer.info.attributes) 
  e_group = get_group(racer) #determine group for racer
  e.group=e_group #assign to entrant
  #create an Entrant result for each Race event
  events.each {|event| e.send("#{event.name}=", event)}
  valid=e.validate
  if valid #if valid, assign new unique bib using atomic increment and save to database
    e.bib=self.next_bib
    e.save
  end
  return e #return e with error information
end

end
