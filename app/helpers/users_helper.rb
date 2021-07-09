module UsersHelper
    
  def get_home_data
    @doubts = Doubt.active_or_resolved.order(created_at: :desc).includes(:user, comments: :user)
  end

end
