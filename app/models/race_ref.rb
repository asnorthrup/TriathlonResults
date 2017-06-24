#embedded model class called RaceRef to hold information about
#the Race that queries of an Entrant will need to immediately know about.

class RaceRef
  include Mongoid::Document
  field :n, as: :name, type: String
  field :date, type: Date

  embedded_in :entrant
  #foreign key will be in RaceRef class embedded within Entrant
  belongs_to :race, foreign_key: "_id"
end
