class StaticPagesController < ApplicationController
  def home
    if current_user.present?
      if current_user.current_role_type == "admin"
        redirect_to admin_root_path
      elsif current_user.current_role_type == "trainer"
        redirect_to trainer_root_path
      end
    end
    @trainees_size = User.trainees.size
    @trainers_size = User.trainers.size
    @courses_size = Course.all.size
  end
end
