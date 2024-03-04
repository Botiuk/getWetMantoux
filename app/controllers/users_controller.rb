class UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update ]
    load_and_authorize_resource

    def index
        @users = User.all.order(:phone)
    end

    def show
    end

    def edit
        if @user.role == "doctor" && @user.doctor.present? && @user.doctor.doctor_status != "fired"
            redirect_to doctors_url, alert: t('alert.change_doctor_role')
        end
        if @user.id == current_user.id
            redirect_to user_url(@user), alert: t('alert.change_my_role')
        end
    end

    def update
        if @user.update(user_params)
            redirect_to user_url(@user), notice: t('notice.update.user')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def user_params
        params.require(:user).permit(:phone, :role, :password, :password_confirmation)
    end

end
