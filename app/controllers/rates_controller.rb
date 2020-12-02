class RatesController < ApplicationController
  before_action :authenticate_user!, only: %i(create update)
  before_action :load_rate_by_id, only: :update
  before_action :find_room, only: %i(create update)

  def create
    @rate = current_user.rates.build rate_params
    if @rate.save
      respond_to :js
    else
      redirect_to root_path
    end
  end

  def update
    if @rate.update rate_params
      respond_to :js
    else
      redirect_to root_path
    end
  end

  private

  def rate_params
    params.permit Rate::RATE_PARAMS
  end

  def load_rate_by_id
    @rate = Rate.find params[:id]
  end

  def find_room
    @room = Room.find params[:room_id]
  end
end
