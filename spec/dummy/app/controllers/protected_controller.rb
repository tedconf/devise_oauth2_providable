class ProtectedController < ApplicationController
  before_action :authenticate_user!
  def index
    render :nothing => true, :status => :ok
  end
end
