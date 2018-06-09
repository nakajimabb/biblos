class UsersController < ApplicationController
  def edit_profile
    @user = current_user
    @bibles = Bible.accessible(current_user.id)
    @used_bibles = current_user.valid_used_bibles.pluck(:bible_id)
    @used_langs = current_user.valid_used_langs.pluck(:lang)
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

  def user_params
    params.require(:user).permit(:code, :nickname, :lang, :password, :password_confirmation, :current_password, :sex, :birthday,
                                 [user_props_attributes: [:id, :user_id, :key, :value, :auth]])
  end
end