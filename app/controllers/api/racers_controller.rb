#controller for the racers
module Api
	class RacersController < ApplicationController
	before_action :set_racer, only: [:show]
		# GET /api/racers
		# GET /api/racers.json
		#represent a collection of racers
		def index
	    	#@racers = Racer.all
	    	if !request.accept || request.accept == "*/*"
				render plain: "/api/racers"
			else
			#real implementation ...
			end
	  	end

		# GET /api/racers/1
		# GET /api/racers/1.json
		#show a specific racer
		def show
		    #@races=@racer.races
		    if !request.accept || request.accept == "*/*"
				render plain: "/api/racers/#{params[:id]}"
			else
				#real implementation ...
			end
		end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_racer
	      #@racer = Racer.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	   #def racer_params
	      #params.require(:racer).permit(:first_name, :last_name, :gender, :birth_year, :city, :state)
	    #end
		
	end
end