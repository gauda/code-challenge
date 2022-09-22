require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(
      email: 'daniel@example.com',
      password: 'someweiredpassword',
      password_confirmation: 'someweiredpassword',
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without matching password' do
    subject.password = 'someweiredpassword!!'
    subject.password_confirmation = 'someweiredpassword'
    expect(subject).to_not be_valid
  end

  it 'raises if undefined status is used' do
    expect { subject.status = 'foo' }.to raise_error(ArgumentError)
  end

  it 'is valid if defined status is used' do
    User.statuses.keys.prepend(nil, '').each do |status|
      subject.status = status
      expect(subject).to be_valid
    end
  end
end
