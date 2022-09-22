class UsersController < ApplicationController
  include Pundit::Authorization
  before_action :set_other_user, except: %w[index]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_paper_trail_whodunnit

  def index
    render jsonapi: User.search(params[:filter])
  end

  def destroy
    @other_user.destroy
    UserMailer.with(user: @other_user).deleted.deliver_now
    render jsonapi: @other_user, status: :ok
  end

  private

  def set_other_user
    authorize(@other_user = User.find(params[:user_id] || params[:id]))
  end

  def user_not_authorized(exception)
   policy_name = exception.policy.class.to_s.underscore

   @user.errors.add(:base, I18n.t("#{policy_name}.#{exception.query}", scope: "pundit", default: :default))
   render jsonapi_errors: @other_user.errors, status: :unprocessable_entity
 end
end
