class SubjectPolicy < ApplicationPolicy
  attr_reader :user, :controller, :action, :user_functions, :record

  def initialize user, args
    @user = user
    @controller_name = args[:controller]
    @action = args[:action]
    @user_functions = args[:user_functions]
    @record = args[:record]
  end

  def show?
    true
  end

  def update?
    @user == @record.user
  end
end
