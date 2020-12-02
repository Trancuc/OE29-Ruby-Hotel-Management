class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :set_locale
  include SessionsHelper

  def render_404
    render file: Rails.root.join("public", "404.html").to_s, layout: false,
           status: :not_found
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "global.please_login"
    redirect_to root_path
  end

  def user_params
    params.required(:user).permit User::USER_PERMIT
  end

  def find_user
    @user = User.find params[:id]
    return if @user
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def bill_range range
    range.present? ? select_range(range) : @user.bills
  end

  def select_range range
    @user.bills.send range
  end
end
