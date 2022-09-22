# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def updated
    UserMailer.with(user: User.last).updated
  end

  def deleted
    UserMailer.with(user: User.last).deleted
  end
end
