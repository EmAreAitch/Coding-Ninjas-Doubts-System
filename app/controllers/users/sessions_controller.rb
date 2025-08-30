# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :redirect_if_signed_in, only: %i[student_login assistant_login]
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def student_login    
    student = Student.first
    sign_in(:user, student)
    redirect_to root_path, notice: "Signed in as student!"
  end

  def assistant_login    
    assistant = TeachingAssistant.first
    sign_in(:user, assistant)
    redirect_to root_path, notice: "Signed in as teaching assistant!"
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def redirect_if_signed_in
    if user_signed_in?
      redirect_to root_path, alert: "Already signed in!"
    end    
  end

end
