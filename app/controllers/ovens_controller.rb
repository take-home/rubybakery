class OvensController < ApplicationController
  before_action :authenticate_user!
  # sets oven and how status
  before_action :set_oven, only: %i[show empty status]

  def index
    @ovens = current_user.ovens
  end

  def empty
    # check how many cookies are done and update storage
    if @oven.cookies.any?
      @oven.cookies.each do |cookie|
        cookie.update_attributes!(storage: current_user)
      end
    end
    redirect_to @oven, alert: 'Oven emptied!'
  end

  # function calculate the oven status
  def status
    if @oven.cookies.any?
      render json: {
        count: @oven.cookies.count,
        ready: @oven.cookies.first.ready?,
        fillings: @oven.cookies.first.fillings
      }
    else
      render json: { count: 0 }
    end
  end

  private

  # function to set oven by user id
  def set_oven
    @oven = current_user.ovens.find_by!(id: params[:id])
  end
end
