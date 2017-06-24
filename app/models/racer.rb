class Racer
  include Mongoid::Document

  #personable is the name of the embedded in parent
  embeds_one :info, class_name: 'RacerInfo', autobuild: true, as: :parent


  before_create do |racer|
  	racer.info.id=racer.id
  end
end
