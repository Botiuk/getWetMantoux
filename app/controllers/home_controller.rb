class HomeController < ApplicationController
  skip_before_action :authenticate_user!  
  before_action :find_user_personal_card 
  
  def index
  end

end
