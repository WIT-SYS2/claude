class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]
  authorize_resource

  def index
    @users = User.with_deleted
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'ユーザを登録しました。' }
        format.json { render action: 'index', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    values = user_params
    if values[:password].blank? && values[:password_confirmation].blank?
      values.delete(:password)
      values.delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(values)
        format.html { redirect_to users_url, notice: 'ユーザーを更新しました。' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user == current_user
      respond_to do |format|
        format.html { redirect_to users_url, alert: '自分自身は削除できません。' }
        format.json { head :no_content }
      end
      return
    end
    @user.update_attributes!(deleted_at: DateTime.now)
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'ユーザを削除しました。' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, role_ids: [])
  end
end
