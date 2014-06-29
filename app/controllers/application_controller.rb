require 'hoover_proxy'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def validate
    raise Exceptionally::BadRequest.new("Must provide company") unless params[:company]
    validate = HooverProxy.new.validate(params[:company], params[:user])
    render json: validate
  end

end
