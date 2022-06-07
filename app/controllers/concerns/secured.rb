module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!

    # We're not really using it, but it's a good example of what is usually done
    attr_reader :current_user
  end

  private

  def authenticate!
    @current_user = User.find(auth_token[:user_id])
  rescue TokenError, ActiveRecord::RecordNotFound
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def auth_token
    TokenService.decode(request.headers['Authorization']&.split(' ')&.last)
  end
end
