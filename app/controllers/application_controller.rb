class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale


  private

  def set_locale
    # NOTE: storing the locale in a session is an anti-pattern according to here: http://guides.rubyonrails.org/i18n.html#storing-the-locale-from-the-session-or-cookies
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale

    if params[:locale].present? && params[:locale] != session[:locale]
      session[:locale] = params[:locale]
    end
  end

end
