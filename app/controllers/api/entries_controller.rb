module Api
	class EntriesController < ApplicationController
	#entries is routed to a single racers entries, so set racer first	
	before_action :set_racer, only: [:show]
	  # GET /api/racers/1/entries
	  # GET /api/racers/1/entries.json
	  #gets all the entries for a specific racer
	  def index
	    #@racers = Racer.all
	    if !request.accept || request.accept == "*/*"
			render plain: "/api/racers/#{params[:racer_id]}/entries"
		else
			#real implementation ...
		end
	  end

	  # GET /api/racers/1/entries/1
	  # GET /api/racers/1/entries/1.json
	  #get a specific entry for a specific racer
	  def show
	    #@races=@racer.races
	    if !request.accept || request.accept == "*/*"
			render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}"
		else
			#real implementation ...
		end
	  end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_racer
	    #  @racer = Racer.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    #def racer_params
	    #  params.require(:racer).permit(:first_name, :last_name, :gender, :birth_year, :city, :state)
	    #end
		
	end
end