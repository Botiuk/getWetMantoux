class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  authorize_resource :class => false

  def index
  end

end
