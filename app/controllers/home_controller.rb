# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  authorize_resource class: false

  def index; end

  def contacts; end
end
