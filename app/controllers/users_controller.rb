class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page]).per_page(Settings.per_page)
  end

  def show
    @microposts = @user.microposts.paginate(page:
      params[:page]).per_page(Settings.count_post)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.users_controller.check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "controller.users_controller.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.users_controller.user_delete"
    else
      flash[:danger] = t "controller.users_controller.delete_fail"
    end
    redirect_to users_path
  end

  def following
    @title = t "users.new.following"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t "users.new.followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controller.users_controller.check_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
    flash[:danger] = t "controller.users_controller.not_user"
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
    flash[:danger] = t "controller.users_controller.not_admin"
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controller.users_controller.user_not_found"
    redirect_to root_path
  end
end
