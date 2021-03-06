class PostsController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @areas = Area.all
    @posts = @q.result(distinct: true).page(params[:page])
  end

  def show
    @like = Like.new
    @post = Post.find(params[:id])
    @area = Area.find(@post.area_id)
    @comments = @post.comments
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿に成功しました"
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @post.image.cache! unless @post.image.blank?
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  def search
    @q = Post.search(search_params)
    @posts = @q.result(distinct: true)
  end

  def rank
    @posts = Post.this_month.size_order
    @users = User.this_month.count_order
    # @users = User.find(Post.this_month.group(:user_id).order('count(user_id) desc').limit(5).pluck(:user_id))
  end

  private
    def post_params
      params.require(:post).permit(:image, :size, :lure, :comment, :area_id, :user_id, :image_cache)
    end

    def correct_user
      post = Post.find(params[:id])
      unless current_user == post.user
        redirect_to posts_path
      end
    end

    def search_params
      params.require(:q).permit!
    end

    def logged_user
      redirect_to posts_path if current_user == nil
    end
end
