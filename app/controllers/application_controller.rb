require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    @upcoming_events = Event.order(start_datetime: :asc).first(10)
    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def menu_options
      if logged_in?
        @user = current_user
        "<li><a href='/user/#{@user.id}'>My Events</a></li><li><a href='/logout'>Logout</a></li>"
      else
        '<li><a href="/login">Login</a></li><li><a href="/signup">Sign Up</a></li>'
      end
    end

    def logged_out_error
      session[:current_errors] = []
      session[:current_errors] << "You must be logged in to view that page"
    end
    
    def password_error
      session[:current_errors] = []
      session[:current_errors] << "Incorrect password. Try again"
    end

  end

end
