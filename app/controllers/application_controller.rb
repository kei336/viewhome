class ApplicationController < ActionController::Base
  
  include SessionsHelper

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
    end
    
    def check_guest
      if current_user.email == 'guest@example.com'
        flash[:danger] = 'ゲストユーザーの為制限されています'
        redirect_to request.referrer
      end
    end
end
