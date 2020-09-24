class HomePagesController < ApplicationController
  def top
    @post = Post.all 
    @feed_items = current_user.postall.paginate(page: params[:page]) if logged_in?
  end

  def about
  end
  
end
