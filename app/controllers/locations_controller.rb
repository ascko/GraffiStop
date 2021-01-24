class LocationsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

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
