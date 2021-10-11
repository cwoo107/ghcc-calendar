class WelcomeController < ApplicationController
  def index
    @year = Date.today.year
    @month = Date.today.month
    @day = Date.today.day
  end
end
