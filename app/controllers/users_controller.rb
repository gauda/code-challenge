class UsersController < ApplicationController
  before_action :set_paper_trail_whodunnit

  def index
    render jsonapi: User.search(params[:filter])
  end

  def destroy
    user = User.find(params[:id])

    if user == current_user
      user.errors.add(:base, 'This user cannot be deleted by you')
      render jsonapi_errors: user.errors, status: :unprocessable_entity
    else
      user.delete
      UserMailer.with(user: user).deleted.deliver_now
      render jsonapi: user, status: :ok
    end
  end
end
