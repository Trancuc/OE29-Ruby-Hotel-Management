class UsersController < ApplicationController
  layout "reservations", only: %i(show edit)
  before_action :authenticate_user!, except: %i(new show create)
  # before_action :find_user, :check_client, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)
#
#   def new
#     @user = User.new
#   end
#
  def show
    @user = User.find params[:id]
    # @bills = bill_range(params[:range]).bill_created_at.page(params[:page])
    #                                    .per Settings.user.page
    # respond_to do |format|
    #   format.js
    #   format.html
    # end
  end
#
#   def create
#     @user = User.new user_params
#     if @user.save
#       @user.send_activation_email
#       flash[:info] = t "global.text_check_email"
#       redirect_to root_url
#     else
#       respond_to :js
#     end
#   end
#
#   def edit; end
#
#   def update
#     if @user.update user_params
#       flash[:success] = t "global.update_success"
#       redirect_to @user
#     else
#       flash.now[:danger] = t "global.update_error"
#       render :edit
#     end
#   end
#
#   private
#
#   def check_client
#     redirect_to root_path unless current_user.client?
#   end
end
