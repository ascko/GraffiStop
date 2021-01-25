class LocationsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  resource_description do
    short "User API"
    description  <<EOF
Location's controller description
EOF
  end

  def_param_group :location do
    param :location, Hash, :action_aware => true do
      param :content, String
      param :verified, :boolean
      param :user_id, Integer
    end
  end


  api :GET, '/locations', "Locations' index"
  description <<EOF
    List locations
EOF

  def index
    @locations = Location.paginate(page: params[:page], :per_page => 10)
  end

  api :GET, '/locations/:id', "Gets location"
  returns :location, :desc => "The location"
  param :id, String, required: true, desc: "id of location"

  def show
    @location = Location.find(params[:id])
  end

  api :POST, '/locations', "Creates a new location"
  param :location, Hash, desc: "Location data" do
    param :content, String, :required => true
    param :verified, :boolean
    param :user_id, Integer, :required => true
  end
  description <<-EOF
    creates a new location
    EOF

  def create
    @location = current_user.locations.build(location_params)
    if @location.save
      flash[:success] = "Location created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end


  api :PUT, '/locations/:id', "Updates location"
  param :id, String, required: true, desc: "id of location"
  param :location, Hash, desc: "Location data" do
    param :content, String
    param :verified, :boolean
    param :user_id, Integer
  end
  returns :location, code: 200, desc: 'Location Object'
  description <<EOF
      updates location
EOF

  def update
    @user = User.update_attributes(user_params)
  end



  api :DELETE, '/locations/:id', "Removes location"
  param :id, String, required: true, desc: "id of location"
  returns :location, code: 204
  description <<EOF
      removes location
EOF

  def destroy
    @location.destroy
    flash[:success] = "Location deleted"
    redirect_to request.referrer || root_url
  end

  private

    def location_params
      params.require(:location).permit(:content)
    end

    def correct_user
      @location = current_user.locations.find_by(id: params[:id])
      redirect_to root_url if @location.nil?
    end

end
