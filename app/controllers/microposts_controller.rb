class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    build_micropost
    if @micropost.save
      flash[:success] = t "microposts.create_micropost"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page:
        params[:page]).per_page(Settings.new_feed)
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.delete_micropost"
    else
      flash[:error] = t "microposts.delete_micropost_fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path unless @micropost
    flash[:warning] = t "microposts.micropost_not_found"
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach(params[:micropost][:image])
  end
end
