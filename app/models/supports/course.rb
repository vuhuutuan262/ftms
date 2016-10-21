class Supports::Course
  attr_reader :course

  def initialize args
    @course = args[:course]
    @namespace = args[:namespace]
    @filter_service = args[:filter_service]
  end

  def course_subjects
    @course_subjects ||= @course.course_subjects.includes(:subject).order_position
  end

  %w(trainees trainers).each do |objects|
    define_method objects do
      instance_variable_set "@#{objects}",
        @course.send("load_#{objects}").users_in_course
    end
  end

  def assigned_user_ids
    @assigned_user_ids ||= @course.user_courses.map &:user_id
  end

  def trainees_assign
    @trainees_assign ||= User.trainees.available_of_course @course.id
  end

  def trainers_assign
    @trainers_assign ||= Role.includes(:users, :user_roles)
      .find_by(name: Settings.roles.trainer).users
  end

  %w(trainee trainer).each do |object|
    define_method "#{object}_courses_handler" do
      instance_variable_set "@#{object}_courses_handler",
        (
          send("#{object}s_assign").map do |object|
          UserCourse.unscoped.find_or_initialize_by user: object,
            course: @course
          end
        )
    end
  end

  def groups
    @groups ||= Group.group_of_user_in_course @course.id
  end

  def subjects
    @subjects ||= Subject.all
  end

  %w(programming_languages locations).each do |objects|
    define_method objects do
      instance_variable_set "@#{objects}",
        objects.classify.constantize.all.collect {|object| [object.name,
        object.id]}
    end
  end

  def courses
    @courses = Course.includes :programming_language, :location
  end

  def filter_data_user
    @filter_data_user ||= @filter_service.user_filter_data
  end

  def course_presenters
    @course_presenters ||= CoursePresenter.new(courses, @namespace).render
  end
end
