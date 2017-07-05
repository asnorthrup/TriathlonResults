#controller that is nested within races
module Api
	class ResultsController < ApplicationController
	before_action :set_racer, only: [:show]
	protect_from_forgery with: :null_session
		# GET /api/races/:race_id/results
		# GET /api/races/:race_id/results.json
		def index
		  #returns entrants of a specified race
		   if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results"
			else
				@race=Race.find(params[:race_id])
				@entrants=@race.entrants
				#pass to index view as locals
				render action: :index, :locals=>{:race=>@race, :entrants=>@entrants}, status: :ok
			end
		end

		# GET /api/races/:race_id/results/:id
		# GET /api/races/:race_id/results/:id.json
		#to represent a a speceific result for a specific race
	  	def show

		    #wrap implementation so will on execute when content-type is not specified. This is so older tests won't fail
		    #during implemnetaiton process
		    if !request.accept || request.accept == "*/*"
				render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
			else
				#real implementation ...
				@result=Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
				render :partial=>"result", :object=>@result
			end
	 	end


	  # PATCH/PUT /api/races/1/results/1
	  # PATCH/PUT /api/races/1/results/1.json
	  def update
	  	entrant=Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
	  	result=params[:result]
		if result
			if result[:swim]
				#byebug
				entrant.swim=entrant.race.race.swim
				entrant.swim_secs = result[:swim].to_f
			end

			if result[:t1]
				entrant.t1=entrant.race.race.t1
				entrant.t1_secs = result[:t1].to_f
			end
			if result[:bike]
				entrant.bike=entrant.race.race.bike
				entrant.bike_secs = result[:bike].to_f
			end
			if result[:t2]
				entrant.t2=entrant.race.race.t2
				entrant.t2_secs = result[:t2].to_f
			end
			if result[:run]
				entrant.run=entrant.race.race.run
				entrant.run_secs = result[:run].to_f
			end
		entrant.save
		render nothing: true, status: :ok
		end
	  end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_racer
	    #   @racer = Racer.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    # def result_params
	    #   params.require(:result).permit(:swim, :t1, :bike, :t2, :run)
	    # end
		
	end
end