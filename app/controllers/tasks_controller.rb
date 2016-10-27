class TasksController < ApplicationController
  before_action :load_task, only: [:update, :destroy]
  before_action :load_user_subject_in_course, only: [:edit, :update, :destroy]
  before_action :load_user_course, only: [:edit, :destroy]
  after_action :verify_authorized

  def create
    @task = current_user.tasks.new task_params
    if authorize @task
      load_user_subject_in_course
      if @task.save
        user_task = @task.user_tasks.find_by user: current_user
        user_task_service = MailerServices::UserTaskService.new user_task: user_task,
          status: Settings.status.init
        @user_task_history = user_task_service.perform
        flash[:success] = flash_message "created"
      else
        flash[:failed] = flash_message "not_created"
      end
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  def update
    if authorize @task
      @old_status = user_task.status
      if @task.update_attributes task_params
        flash[:success] = flash_message "updated"
      else
        flash[:failed] = flash_message "not_updated"
      end
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  def destroy
    if authorize user_task
      if @task.destroy
        flash[:success] = flash_message "deleted"
      else
        flash[:failed] = flash_message "not_deteletd"
      end
      redirect_to :back
    else
      redirect_to root_path
    end
  end

  private
  def task_params
    params.require(:task).permit Task::ATTRIBUTES_PARAMS
  end

  def load_user_subject_in_course
    @user_subject = UserSubject.find_by user: current_user,
      course_subject: @task.course_subject
  end

  def load_user_course
    @course_subject = @task.course_subject
    @user_course = current_user.user_courses.find_by course_id: @course_subject.course_id
  end

  def user_task
     @task.user_tasks.first
  end
end
