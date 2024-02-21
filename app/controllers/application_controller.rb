class ApplicationController < ActionController::Base
    include ApplicationHelper
    
    before_action :authenticate_user!
    before_action :find_user_personal_card

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, alert: t('alert.access_denied')
    end
    
end
