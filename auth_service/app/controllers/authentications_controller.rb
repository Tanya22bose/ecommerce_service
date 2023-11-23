class AuthenticationsController < ApplicationController
  def register
    user = User.new(user_params)
    if user.save
      token = User.encode_token({user_id: user.id})
      render json: {user: user, token: token, message: "User was successfully registered"}, status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = User.encode_token({user_id: user.id})
      render json: {user: user, token: token, message: "User logged in successfully"}, status: :ok
    else 
      render json: {error: "Invalid Email or Password"}, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end