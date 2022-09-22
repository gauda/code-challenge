class ArchivesController < UsersController
  def create
    @other_user.update(status: 'archived')
    UserMailer.with(user: @other_user).updated.deliver_later
    render jsonapi: @other_user, status: :created
  end

  def destroy
    @other_user.update(status: 'active')
    UserMailer.with(user: @other_user).updated.deliver_later
    render jsonapi: @other_user, status: :ok
  end
end
