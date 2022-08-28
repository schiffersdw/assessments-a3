# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(params[:email])
    if @user&.active && @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.zone.now + 12.hours.to_i
      render json: {
        token:, exp: time.strftime('%Y%m%d%H%M'),
        username: @user.username,
        name: @user.name
      }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
