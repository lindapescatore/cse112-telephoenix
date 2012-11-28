class UserController < ApplicationController
  
  before_filter :login_required, :only=>['welcome', 'change_password']
  
  def register
    @user = User.new(params[:user])
    @user.user_type = "user"
    if request.post?
      if @user.save
        session[:user] = User.authenticate(@user.username, @user.password)
        flash[:message] = "Signup successful"
        
        if current_user.user_type == "Moderator"
          redirect_to moderators_path
        else
        redirect_to :controller => "phones" #TODO redirect to welcome page
        end
      else
        flash[:warning] = "Signup unsuccessful"
      end
    end
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:username], params[:user][:password])
        flash[:message] = "Login successful"
        #debugger
        if current_user.user_type == "Moderator"
          redirect_to moderators_path
        else
          redirect_to_stored
        end
      else
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = "Logged out"
    redirect_to :action => "login"
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to moderators_path, :notice => "The post has been deleted"
  end


  def show
    @user = User.find(params[:id])
    @reviews = Review.find_all_by_user_id(params[:id])
  end

end
