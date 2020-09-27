class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :index, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @post = current_user.posts.build if logged_in?
  end

  def index
    @feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
    @comment = @post.comments.build(user_id: current_user.id) if current_user
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = "投稿しました"
      redirect_to posts_url
    else
      @feed_items = current_user.posts.build(post_params)
      render 'posts/new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] ="投稿を削除しました"
    redirect_to request.referrer || posts_url
  end

  def ranking
    @posts = Post.all.sort{|a,b| b.liked_users.count <=> a.liked_users.count}
  end

  private

    def post_params
      params.require(:post).permit(:name, :content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
