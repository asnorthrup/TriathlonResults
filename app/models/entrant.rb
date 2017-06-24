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
  #embeds race as raceref of class RaceRef
  embeds_one :race, class_name: "RaceRef"

  #after a result is added or removed (see embeds_many callbacks) the seconds is recalculated for the 
  #entrant. All secs of each result are added up again, so passed in result isn't used.
  def update_total(result)
  	self.secs=0
  	results.each do |r|
  		self.secs = self.secs + r.secs
  	end 
  end

  #custom getter that retuns the results of race.race, first race references the embeded RaceRef and the second
  #race reference the Race document in the other race collection
  def the_race
  	race.race
  end

end
