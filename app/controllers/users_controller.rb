class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def home
    @user = current_user
    @bread_crumb = [['ホーム', nil]]
    @articles = Article.accessible(current_user.id).where('created_at > ?', Date.today - 7)
    @articles = @articles.order(created_at: :desc)
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

  def send_invitation
    begin
      raise 'Emailを入力してください' if params[:email].blank? or params[:email].blank?
      raise '氏名を入力してください' if params[:first_name].blank? and params[:last_name].blank?
      nickname = params[:last_name].to_s + ' ' + params[:first_name].to_s
      user = User.invite!({email: params[:email], nickname: nickname, lang: :ja}, current_user)
      if user.present?
        if params[:first_name].present?
          user_prop = user.user_props.find_or_initialize_by(key: :first_name)
          user_prop.update!(value: params[:first_name], auth: :auth_user)
        end
        if params[:last_name].present?
          user_prop = user.user_props.find_or_initialize_by(key: :last_name)
          user_prop.update!(value: params[:last_name], auth: :auth_user)
        end
      end
      redirect_to root_path, notice: '招待メールを送信しました'
    rescue => e
      flash[:alert] = e.message
      render 'invitation'
    end
  end

private
  def set_user
    @user = @target_user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:code, :nickname, :lang, :password, :password_confirmation, :current_password, :sex, :birthday, :avatar,
                                 [user_props_attributes: [:id, :user_id, :key, :value, :auth]])
  end
end
