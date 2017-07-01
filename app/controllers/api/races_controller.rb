#controller for the races
module Api
	class RacesController < ApplicationController
	#must protect from forgery for controller class for the API to use when implementing POST HTTP method actions
	#from web service clients
	protect_from_forgery with: :null_session
	before_action :set_racer, only: [:show]
	  # GET /api/races
	  # GET /api/races.json
	  #collection of races that can handle a query string with pagining parameters
	  def index
	    #@racers = Racer.all
	    if !request.accept || request.accept == "*/*"
				render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
		else
			#@racers = Racer.all
			#todo implement
		end
	  end

	  # GET /api/races/1
	  # GET /api/races/1.json
	  #a specific race
	  def show
	    #@races=@racer.races
	    if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:id]}"
		else
			#real implementation ...
		end
	  end


	  # POST /races
	  # POST /races.json
	  def create
		if !request.accept || request.accept == "*/*"
			render plain: "#{params[:race][:name]}", status: :ok
			#return params[:"race.name"]
			#byebug
			
		else
			#real implementation
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