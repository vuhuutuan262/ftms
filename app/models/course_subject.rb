class CourseSubject < ApplicationRecord
  acts_as_paranoid

  include PublicActivity::Model
  include InitUserSubject
  include RankedModel

  mount_uploader :image, ImageUploader

  ATTRIBUTES_PARAMS = [:subject_name, :image, :subject_description, :subject_content,
    :course_id, :row_order_position, :chatwork_room_id]

  belongs_to :subject
  belongs_to :course

  has_many :user_subjects, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :activities, as: :trackable, class_name: "PublicActivity::Activity", dependent: :destroy

  after_create :create_tasks
  after_create :create_user_subjects_when_add_new_subject
  after_create :update_subject_course

  accepts_nested_attributes_for :tasks, allow_destroy: true,
    reject_if: proc {|attributes| attributes["name"].blank?}

  scope :order_position, ->{rank :row_order}
  scope :load_course_subjects_for_trainer, ->trainer_id do
    joins(course: :user_courses).where("user_courses.user_id = ?
      AND courses.status = ?", trainer_id, Course.statuses[:progress])
      .group_by &:subject_id
  end

  delegate :name, to: :course, prefix: true, allow_nil: true
  delegate :during_time, to: :subject, prefix: true, allow_nil: true

  ranks :row_order, with_same: :course_id

  def finished?
    status = true
    self.user_subjects.each do |user_subject|
      return status = false
    end
    status
  end

  private
  def update_subject_course
    self.update_attributes subject_name: subject.name,
      subject_description: subject.description,
      subject_content: subject.content, image: subject.image
  end

  def create_user_subjects_when_add_new_subject
    trainee_role = Role.find_by name: "trainee"
    create_user_subjects course.user_courses.find_user_by_role(trainee_role.id),
      [self], course_id
  end

  def create_tasks
    subject.task_masters.each do |task_master|
      Task.create course_subject_id: id, name: task_master.name,
        description: task_master.description, task_master_id: task_master.id
    end
  end
end
