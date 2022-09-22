class UserPolicy < ApplicationPolicy
  attr_reader :user, :other_user

  def initialize(user, other_user)
    @user = user
    @other_user = other_user
  end

  def create?
    user != other_user
  end

  def destroy?
    create?
  end
end
