class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @location = current_user.locations.build
      @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 8)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
