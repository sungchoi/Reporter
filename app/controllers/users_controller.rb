class UsersController < ApplicationController
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Reporter App!"
      redirect_to user_path(@user)
    else
      flash[:error] = "User creation failed: #{@user.errors.full_messages.join("\n")}"
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def destroy
   @user = User.find(params[:id])
   @user.destroy
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports
  end

end
