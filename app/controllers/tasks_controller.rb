class TasksController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course_subject
  before_action :load_user_subject, only: [:create, :edit, :update, :destroy]
  before_action :add_task_info, only: [:create]
  before_action :load_user_course, only: [:edit, :destroy]

  def create
    if @task.save
      flash[:success] = flash_message "created"
    else
      flash[:failed] = flash_message "not_created"
    end
    redirect_to :back
  end

  def edit
  end

  def update
    @old_status = user_task.status
    if @task.update_attributes task_params
      track_activity
      flash[:success] = flash_message "updated"
      redirect_to :back
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = flash_message "deleted"
      redirect_to user_course_subject_path @user_course, @user_subject.subject
    else
      flash[:failed] = flash_message "not_deteletd"
      redirect_to :back
    end
  end

  private
  def task_params
    params.require(:task).permit Task::ATTRIBUTES_PARAMS
  end

  def add_task_info
    @task.create_by_trainee = current_user.is_trainee?
    @task.course_subject = @course_subject
  end

  def load_user_subject
    @user_subject = UserSubject.find_by user: current_user,
      course_subject: @course_subject
  end

  def load_user_course
    @user_course = current_user.user_courses.find_by course_id: @course_subject.course_id
  end

  def track_activity
    new_status = user_task.status
    unless @old_status == new_status
      user_task.create_activity key: "user_task.change_status", owner: current_user,
        parameters: {old_status: @old_status, new_status: new_status}
    end
  end

  def user_task
     @task.user_tasks.first
  end
end
