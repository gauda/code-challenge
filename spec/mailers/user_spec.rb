require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "updated" do
    let(:user) do
      User.create(
        email: 'danie@example.com',
        password: 'supersecurepassword',
        password_confirmation: 'supersecurepassword',
        )
    end

    let(:mail) { UserMailer.with(user: user).updated }

    it "renders the headers" do
      expect(mail.subject).to eq("Your status changed")
      expect(mail.to).to eq(["danie@example.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your status changed to active")
    end
  end

  describe "deleted" do
    let(:user) do
      User.create(
        email: 'danie@example.com',
        password: 'supersecurepassword',
        password_confirmation: 'supersecurepassword',
        )
    end

    let(:mail) { UserMailer.with(user: user).deleted }

    it "renders the headers" do
      expect(mail.subject).to eq("Your user is deleted")
      expect(mail.to).to eq(["danie@example.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your user is deleted")
    end
  end
end
