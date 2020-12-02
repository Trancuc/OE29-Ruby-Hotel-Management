class ReservationsController < ApplicationController
  layout "reservations"
  before_action :authenticate_user!
  def index
    @rooms = Room.valid_room(params[:checkin], params[:checkout])
                 .page(params[:page])
                 .per Settings.reservation.page
    @checkin = params[:checkin]
    @checkout = params[:checkout]
  end

  def show
    @room = Room.find params[:id]
    @rooms = Room.valid_room(params[:checkin_room], params[:checkout_room])
    @available = @rooms.include? @room
    respond_to do |format|
      format.html{redirect_to @room}
      format.js
    end
  end
end
