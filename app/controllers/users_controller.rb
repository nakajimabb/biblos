class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def home
    @user = current_user
    @bread_crumb = [['ホーム', nil]]
    render 'show'
  end

  def show
    @bread_crumb = [[@user.nickname, nil], ['トップ', nil]]
  end

  def edit_profile
    @user = current_user
    @bibles = Bible.accessible(current_user.id)
    @used_bibles = current_user.valid_used_bibles.pluck(:bible_id)
    @used_langs = current_user.valid_used_langs.pluck(:lang)
    @bread_crumb = [['ユーザ設定', users_edit_profile_path]]
  end

  def update_profile
    begin
      @user = current_user
      user_p = user_params

      if user_p[:password].blank? && user_p[:password_confirmation].blank?
        user_p.delete(:password)
        user_p.delete(:password_confirmation)
      end
      if user_p[:first_name_en].blank? && user_p[:first_name_kana].present?
        user_p[:first_name_en] = Romaji.kana2romaji(user_p[:first_name_kana]).capitalize
      end
      if user_p[:last_name_en].blank?  && user_p[:last_name_kana].present?
        user_p[:last_name_en]  = Romaji.kana2romaji(user_p[:last_name_kana]).capitalize
      end

      @user.attributes = user_p
      @user.save!

      redirect_back(fallback_location: root_path, notice: '更新しました')
    rescue => e
      redirect_back(fallback_location: root_path, alert: e.message)
    end
  end

  def update_used_bibles
    begin
      current_user.used_langs.destroy_all
      if params[:selected_langs].present?
        params[:selected_langs].each do |lang|
          current_user.used_langs.create(lang: lang)
        end
      end

      current_user.used_bibles.destroy_all
      if params[:selected_bibles].present?
        params[:selected_bibles].each do |bible_id|
          current_user.used_bibles.create(bible_id: bible_id)
        end
      end

      redirect_back(fallback_location: root_path, notice: '更新しました')
    rescue => e
      redirect_back(fallback_location: root_path, alert: e.message)
    end
  end

private
  def set_user
    @user = @target_user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:code, :nickname, :lang, :password, :password_confirmation, :current_password, :sex, :birthday,
                                 [user_props_attributes: [:id, :user_id, :key, :value, :auth]])
  end
end
