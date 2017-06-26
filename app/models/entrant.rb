class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps

  #store entrants in the results colleciton - manually map, otherwise would be in entrants colleciton
  store_in collection: "results"

  field :bib, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  #since result isn't same name as LegResult, must give class name
  embeds_many :results, class_name: "LegResult", order: [:"event.o".asc], after_add: :update_total, after_remove: :update_total
  #embeds race as raceref of class RaceRef; autobuild so embedded objects are created when needed  
  embeds_one :race, class_name: "RaceRef", autobuild: true
  #bi-directional 1:1 embedded polymorphic relationsihp between Entrant and RacerInfo. Racer holds a copye of
  #this info and will be considered the master copy. Entrant stores a copy for acessing during race result processing.
  #; autobuild so embedded objects are created when needed
  embeds_one :racer, as: :parent, class_name: "RacerInfo", autobuild: true
  #after a result is added or removed (see embeds_many callbacks) the seconds is recalculated for the 
  #entrant. All secs of each result are added up again, so passed in result isn't used.
  
  #named scopes for finding chainable criteria for entrants that have not completed and have occured in the past
  scope :past, ->{where(:"race.date".lt=>Date.current)}
  scope :upcoming, ->{where(:"race.date".gte=>Date.current)}

  def update_total(result)
  	self.secs=0
  	results.each do |r|
      if !r.secs.nil?
  		  self.secs = self.secs + r.secs
      end
  	end 
  end

  #custom getter that retuns the results of race.race, first race references the embeded RaceRef and the second
  #race reference the Race document in the other race collection
  def the_race
  	race.race
  end

  #delegate the RacerInfo properties, for example changes racer.first_name to 'first_name'
  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: "racer" #adds racer_ prefix to gender to differentiate
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer

  #RaceRef properties need a race_ prefix added to the property to differentiate from other names
  delegate :name, :name=, to: :race, prefix: "race"
  delegate :date, :date=, to: :race, prefix: "race"

  #the nil check delegation to the custom classes is implemented through a set of custom accessor methods.
  def overall_place
    overall.place if overall
  end

  def gender_place
    gender.place if gender
  end

  def group_name
    group.name if group
  end

  def group_place
    group.place if group
  end

  #use metaprogramming to map property support of Entrant class relative to Leg result.
  #hash of event names to result class implementations
  RESULTS = {"swim"=>SwimResult,
            "t1"=>LegResult,
            "bike"=>BikeResult,
            "t2"=>LegResult,
            "run"=>RunResult}


  #each case of keys in results hash creates the properties
  RESULTS.keys.each do |name| #outer loop targeted at each event name
    #create_or_find result - getter method for the event that will find the event in the events collection
    #or create a new one that has ben inserted into the collection
    define_method("#{name}") do
      result=results.select {|result| name==result.event.name if result.event}.first #find event
      if !result #create event and add to events collection
        result=RESULTS["#{name}"].new(:event=>{:name=>name})
        results << result
      end
      result
    end
    #assign event details to result
    #previous getter locates or creates the result, this will embed the details of the event in that result
    define_method("#{name}=") do |event|
      event=self.send("#{name}").build_event(event.attributes)
    end

    #expose setter/getter for each attribute in the result classes. This adds a _secs and event specific property
    #to Entrant class. Setter manually calls the collection callback to re-calculate the total secs, since this doesn't
    #change the collection, only changes the result within the collection 
    #
    RESULTS["#{name}"].attribute_names.reject {|r|/^_/===r}.each do |prop|
      define_method("#{name}_#{prop}") do
        event=self.send(name).send(prop)
      end
      define_method("#{name}_#{prop}=") do |value|
       event=self.send(name).send("#{prop}=",value)
       update_total nil if /secs/===prop
      end
    end 
  end

end
