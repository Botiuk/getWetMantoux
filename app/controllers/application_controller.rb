class ApplicationController < ActionController::Base
    include ApplicationHelper
    
    before_action :authenticate_user!
    before_action :find_user_personal_card
end
