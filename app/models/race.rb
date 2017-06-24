#act as the root-level document in the races collection ingested in the initial section

class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address

  #relationship with events, relationship is polymophic type as parent, default ascending sort based on order field
  embeds_many :events, as: :parent, order: [:order.asc]

  #named scopes for finding races current and future
  scope :past, ->{where(:date.lt=>Date.current)}
  scope :upcoming, ->{where(:date.gte=>Date.current)}

end
