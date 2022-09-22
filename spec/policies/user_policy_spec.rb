require 'spec_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { User.new }
  let(:other_user) { User.new }

  subject { described_class }

  permissions :create?, :destroy? do
    it "denies action if user is other_user" do
      expect(subject).not_to permit(user, user)
    end

    it "grants action if user is not other_user" do
      expect(subject).to permit(user, other_user)
    end
  end
end
