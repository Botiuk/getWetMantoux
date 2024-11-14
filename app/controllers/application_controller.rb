# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :find_user_personal_card

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_url, alert: t('alert.access_denied')
  end
end
