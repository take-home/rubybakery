class CookiesController < ApplicationController
  before_action :authenticate_user!
  # starts oven
  before_action :set_oven, only: %i[new create]

  def new
    # implemented feature multiple cookies in the oven
    if @oven.cookies.any?
      redirect_to @oven, alert: 'The cookies are in the oven!'
    else
      @cookie = @oven.cookies.build
    end
  end

  def create
    # start count the cookies
    begin
      quantity = params[:quantity].to_i
    rescue StandardError
      quantity = 0
    end

    # start count the oven time
    begin
      oven_time = params[:oven_time].to_f
    rescue StandardError
      oven_time = 0
    end

    unless quantity.positive?

      redirect_to new_oven_cookies_path, alert: 'You must enter a valid quantity!'
      return
    end

    unless oven_time.positive?
      redirect_to new_oven_cookies_path, alert: 'You must enter a valid oven time for your cookies!'
      return
    end

    quantity.times do
      @cookie = @oven.cookies.create!(cookie_params)
    end
    redirect_to oven_path(@oven)
    # used Sidekiq to have cookies being cooked async incresing productivety and performance
    CookiesWorker.perform_async(@oven.id, oven_time)
    end
  end

  private

  def set_oven
    @oven = current_user.ovens.find_by!(id: params[:oven_id])
  end

  def cookie_params
    params.require(:cookie).permit(:fillings)
    # covers empty string edge case
    result_params = params.require(:cookie).permit(:fillings)
    result_params.delete(:fillings) if result_params[:fillings].empty?
    result_params
  end
end
