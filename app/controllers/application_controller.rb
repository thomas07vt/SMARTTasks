class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller? 

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end  

  def authenticate
    authenticate_or_request_with_http_basic do |email, password|
      logger.info "username: #{email}, pass: #{password}"
      user = User.find_by_email(email)
      if !user.nil?
        user.valid_password?(password)
      else
        false
      end
    end
  end

end
