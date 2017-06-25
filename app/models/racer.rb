class Racer
  include Mongoid::Document

  #personable is the name of the embedded in parent
  embeds_one :info, class_name: 'RacerInfo', autobuild: true, as: :parent
  #1:M relationship btwn racer and entrant, foreign key stored in the Entrant.RacerInfo embedded class
  has_many :races, class_name: 'Entrant', foreign_key: "racer.racer_id", dependent: :nullify, order: :"race.date".desc

  before_create do |racer|
  	racer.info.id=racer.id
  end

  #deletgate calls so that you don't have to use racerinstance.info.last_name, just use racerinstance.last_name
  delegate :first_name, :first_name=, to: :info
  delegate :last_name, :last_name=, to: :info
  delegate :gender, :gender=, to: :info
  delegate :birth_year, :birth_year=, to: :info
  delegate :city, :city=, to: :info
  delegate :state, :state=, to: :info
end
