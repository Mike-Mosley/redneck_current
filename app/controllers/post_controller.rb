class PostController < ApplicationController
  layout 'roundup'
  before_filter :check_login


  def index
    @post = Post.find(params[:id])
  end

  private

  def check_login
    if current_user.nil?
      redirect_to :controller => 'user', :action => 'login_page'
    end
  end
end
