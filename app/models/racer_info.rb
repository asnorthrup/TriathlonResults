class RacerInfo
  include Mongoid::Document
  #note on aliases, you want the shorter alias to be first as that is what the db stores
  #longer alias is used in models for code clarity
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

	#_id field to be mapped to the document key racer_id and have its default value set to the value
	# of racer_id. Declare the field as untyped so that whatever _id type is in the Racer can be stored in this
	# field. The intent here is to have the id field stored in the document as racer_id and not have a duplicate
	#_id
  field :racer_id, as: :_id
  field :_id, default:->{racer_id}

  #parent is the name of the relationship that is polymorphic
  embedded_in :parent, polymorphic: true

  validates_presence_of :first_name, :last_name, :gender, :birth_year
  validates :gender, inclusion: {in:['M','F']}
  validates :birth_year, numericality: {less_than: Date.today.year}

end
