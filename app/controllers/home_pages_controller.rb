class HomePagesController < ApplicationController
  def top
    @posts = Post.paginate(page: params[:page], per_page: 12)
  end

  def about
  end
  
end
