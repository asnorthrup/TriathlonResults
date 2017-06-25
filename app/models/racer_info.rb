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

  #use metaprogramming and dynamically create getter/setter for each property needed
  #define method declares a block that defines a particular method and the method can optionally take parameters
  #object.send("m",123) invokes method m on the object and can optionally pass parameters to that method
  #notes - just as name and name=(param) are getter and setters for name – object.send("name") and
  #object.send("name=", value) are also getter and setter methods that can dynamically access object
  #methods without knowing the type ahead of time.

  #the following creates setters and getters for each address property within this class, making sure to apply the
  #single field change to an entire instance of Account that was created from the current state and reassigned as whole object
  ["city", "state"].each do |action| #city/state is an array passed in as the action to perform
    
    define_method("#{action}") do #acts as getter
      self.residence ? self.residence.send("#{action}") : nil #pulls the desired field from the embedded custom type
    end
    define_method("#{action}=") do |name| #acts as setter
      object=self.residence ||= Address.new(nil,nil,nil) #create an address if needed, address.new relies on fact there is Address.initialize() with no args
      object.send("#{action}=", name) #apply value to desired field
      self.residence=object #re-assigns the state for the entire custom type
    end
  end




end
