class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  layout :layout_by_resource


  private 

  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

end
