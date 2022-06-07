class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render(json: {user: user.email, token: token(user)}, status: :created)
    else
      render(json: user.errors, status: :unprocessable_entity)
    end
  end

  def login
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      render json:{user: user.email, token: token(user)}
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def token(user)
    TokenService.encode({user_id: user.id})
  end
end
