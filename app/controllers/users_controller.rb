class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    def create
       @user = User.create(user_params)
       if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
       else
            render json: {message: "Username/password tidak boleh kosong"}, status: :bad_request
       end 
    end

    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token, message: "Selamat datang"}
        else
            render json: {message: "Username/password salah"}, status: :bad_request
        end
    end

    def auto_login
        render json: @user
    end

    private

    def user_params
        params.permit(:username, :password)
    end
end
