class UserController < ApplicationController
  layout 'application'

  def index
    @user = session[:current_user].nil? ? User.new : User.new
  end

  def login
    @user = User.authenticate(params[:user][:username],params[:user][:password])
  end

  def create
    @user = User.create(params[:user])
    if @user.save
      redirect_to :action => 'finish_registration', :id => @user.id
    else
      render 'index'
    end
  end

  def finish_registration
    @user = User.find(params[:id])
  end

  def complete_registration
    @user = User.find(params[:id])
    @user.sex_id = params[:user][:sex_id]
    @user.relationship_status_id = params[:user][:relationship_status_id]
    @user.date_of_birth = params[:user][:date_of_birth]
    if @user.save(:validate => false)
      @user.send_confirmation
      redirect_to :action => 'share_redneck_roundup', :id => @user.id
    else
      render 'finish_registration'
    end
  end

  def share_redneck_roundup
    @user = User.find(params[:id])
  end
end
