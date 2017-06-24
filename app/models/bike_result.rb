class BikeResult<LegResult
  include Mongoid::Document
  field :mph, type: Float

  #saves the average miles per hour
  def calc_ave
  	#event in secs are embedded events from in parent leg_results
  	if event && secs
  		miles = event.miles
  		self.mph=miles.nil? ? nil : miles/(secs/60/60) #60 secs/min and 60 min/hr to go from mile/sec to mile/hr
  	end  
  end

end
