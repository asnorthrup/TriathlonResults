#controller that is nested within races
module Api
	class ResultsController < ApplicationController
	before_action :set_racer, only: [:show]
		# GET /api/races/:race_id/results
		# GET /api/races/:race_id/results.json
		def index
		  #@racers = Racer.all
		   if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results"
			else
				#real implementation ...
			end
		end

		# GET /api/races/:race_id/results/:id
		# GET /api/races/:race_id/results/:id.json
		#to represent a a speceific result for a specific race
	  	def show
		    #@races=@racer.races
		    #wrap implementation so will on execute when content-type is not specified. This is so older tests won't fail
		    #during implemnetaiton process
		    if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
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