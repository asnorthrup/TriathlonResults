class SwimResult<LegResult
  include Mongoid::Document
  field :pace_100, type: Float

  #saves the time to complete 100 meters over the course of the race
  def calc_ave
  	#event in secs are embedded events from in parent leg_results
  	if event && secs
  		meters = event.meters
  		self.pace_100=meters.nil? ? nil : (secs/meters)*100
  	end
  end  
end
