class RunResult<LegResult
  include Mongoid::Document
  field :mmile, as: :minute_mile, type: Float

  #for run result average time to complete one mile given the length and time to complet the course
  def calc_ave
  	#event in secs are embedded events from in parent leg_results
  	if event && secs
  		miles = event.miles
  		self.minute_mile=miles.nil? ? nil : (secs/60)/miles
  	end
  end
end
