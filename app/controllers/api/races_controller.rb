#controller for the races
module Api
	class RacesController < ApplicationController
	#must protect from forgery for controller class for the API to use when implementing POST HTTP method actions
	#from web service clients
	protect_from_forgery with: :null_session
	before_action :set_race, only: [:show, :update, :destroy]

	rescue_from ActionController::UnknownFormat do |exception|
		Rails.logger.debug exception
		render plain: "woops: we do not support that content-type[#{request.accept}]", status: 415
	end

	  # GET /api/races
	  # GET /api/races.json
	  #collection of races that can handle a query string with pagining parameters
	  def index
	    #@racers = Racer.all
	    if !request.accept || request.accept == "*/*"
			render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
		else
			#races = Race.all
			#todo implement
		end
	  end

	  # GET /api/races/1
	  # GET /api/races/1.json
	  #a specific race
	  def show
	    if !request.accept || request.accept == "*/*"
			render plain: "/api/races/#{params[:id]}"
		elsif request.accept == "application/json" || request.accept == "application/xml"
			if @race
	    		render action: :show, status: :ok
	        else
	        	render :status=>:not_found,
						:template=>"api/error_msg",
						:locals=>{ "msg":"woops: cannot find race[#{params[:id]}]"}
	        end
		else
			respond_to do |format|
				format.json {render action: :show, status: :ok}
				format.xml {render action: :show, status: :ok}
			end
		end
	  end


	  # POST /api/races
	  # POST /api/races.json
	  def create
	  	#byebug
		if !request.accept || request.accept == "*/*"
			render plain: "#{params[:race][:name]}", status: :ok
			#render plain: :nothing, status: :ok
		else
			#real implementation
			#not sure if race needs to be class variable
		    @race = Race.create(race_params)
		    #byebug
		    render plain: "#{@race.name}", status: :created
		    # respond_to do |format|
		    #   if @race.save
		    #     format.html { redirect_to @race, notice: 'Race was successfully created.' }
		    #     format.json { render :show, status: :created, location: @race }
		    #   else
		    #     format.html { render :new }
		    #     format.json { render json: @race.errors, status: :unprocessable_entity }
		    #   end
		    # end
		end
	  end

	  # PATCH/PUT /api/races/1
	  # PATCH/PUT /api/races/1.json
	  def update
	  	#byebug
	  	if @race
	  		@race.update(race_params)
	  		render json: @race, status: :ok
	  	else
			render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
		end

	    # respond_to do |format|
	    #   if @race.update(race_params)
	    #     format.html { redirect_to @race, notice: 'Race was successfully updated.' }
	    #     format.json { render :show, status: :ok, location: @race }
	    #   else
	    #     format.html { render :edit }
	    #     format.json { render json: @race.errors, status: :unprocessable_entity }
	    #   end
	    # end
	  end

	  def destroy
	  	if @race
	  		@race.destroy
	  		render nothing: true, status: :no_content
	  	else
			render nothing: true, status: :not_found
		end
	    
	    # respond_to do |format|
	    #   format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
	    #   format.json { head :no_content }
	    # end
	  end


	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_race
	      @race=Race.where(:_id=>params[:id]).first
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def race_params
	      params.require(:race).permit(:name, :date)
	    end
		
	end
end