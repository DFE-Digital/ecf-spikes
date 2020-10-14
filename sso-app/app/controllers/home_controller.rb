class HomeController < ApplicationController
  before_action :go_to_dashboard_if_authenticated!
  def index; end
end
