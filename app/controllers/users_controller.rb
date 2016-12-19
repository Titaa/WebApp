class UsersController < ApplicationController
 before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy

  def index
   @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
     @microposts = @user.microposts.paginate(page: params[:page])
    end

    def new
      @user = User.new
    end

    def create
     @user = User.new(user_params)
     respond_to do |format|
     if @user.save
       format.html { redirect_to @user, notice:'Bienvenue dans la famille !'}
       format.json {render :show,status: :created,location: @user}
       # Handle a successful save.
     else
       format.html {render :new}
       format.json {render json: @user.errors, status: :unprocessable_entity}
     end
   end
 end

   def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
     respond_to do |format|
    if @user.update_attributes(user_params)
      # Handle a successful update.
      format.html { redirect_to @user, notice:'Profil bien mis à jour!'}
      format.json {render :show,status: :ok,location: @user}
    else
      format.html {render :edit}
      format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
   User.find(params[:id]).destroy
    respond_to do |format|
   format.html { redirect_to users_url, notice:'User supprimé !'}
   format.json {head :no_content}
 end
 end

   private

   def user_params
     params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
   end

     # Before filters

    # Confirms the correct user.
   def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
   end

   def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
