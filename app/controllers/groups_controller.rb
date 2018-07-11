class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :members]

  def index
    @groups = Group.where(group_type: :community)
  end

  def show
    @target_group = @group
    @bread_crumb = [[@group.name, nil], ['トップ', nil]]
  end

  def detail
    @group = Group.find_by(code: params[:group_code], group_type: :community)
    if @group.present?
      @target_group = @group
      @bread_crumb = [[@group.name, nil], ['トップ', nil]]
      render :show
    else
      render file: Rails.root.join('public').join('404'), :layout => false, :status => :not_found
    end
  end

  def members
    @users = @group.users.where(group_users: {member_type: :normal})
    @bread_crumb = [[@group.name, nil], ['メンバー', nil]]
  end

private
  def authenticate_user!
  end

  def set_group
    @group = @target_group = Group.find(params[:id])
  end

  def group_params
    params.fetch(:group, {})
  end
end
