class StatusController < ApplicationController
  def show
    raise "Lost database connection" unless ActiveRecord::Base.connection.active?
    render :text => "success"
  end
end
