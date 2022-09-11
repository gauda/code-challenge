class ArchivesController < ApplicationController
  before_action :set_paper_trail_whodunnit

  def create
    user = User.find(params[:user_id])

    if user == current_user
      user.errors.add(:status, 'cannot be changed by you')
      render jsonapi_errors: user.errors, status: :unprocessable_entity
    else
      user.update(status: 'archived')
      UserMailer.with(user: user).updated.deliver_later
      render jsonapi: user, status: :created
    end
  end

  def destroy
    user = User.find(params[:user_id])

    if user == current_user
      user.errors.add(:status, 'cannot be changed by you')
      render jsonapi_errors: user.errors, status: :unprocessable_entity
    else
      user.update(status: 'active')
      UserMailer.with(user: user).updated.deliver_later
      render jsonapi: user, status: :ok
    end
  end
end
