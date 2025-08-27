class DoubtsController < ApplicationController
  def index
    flash[:alert] = "ERROR"
    flash[:notice] = "SUCCESS"
  end
end
