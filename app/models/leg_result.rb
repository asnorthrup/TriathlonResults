class LegResult
  include Mongoid::Document
  field :secs, type: Float

  embedded_in :entrant
  embeds_one :event, as: :parent

  #event will supply a sort order required by entrant
  validates_presence_of :event

	#empty callback method that is used by sub-classes to update their event specific
	#averages based on the details of the event and the time to complete in secs
  def calc_ave

  end

  #invokes calc_ave
  after_initialize do |doc|
  	#work on this
  	doc.calc_ave
  end
  #override the set seconds method such that it calls calc_ave to refresh averages calculated
  #after it manually updates self[:secs] with provided value
  def secs= value
  	self[:secs]=value
  	calc_ave
  end
end
