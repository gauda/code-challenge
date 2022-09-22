require 'rails_helper'

RSpec.describe "Archives", type: :request do
  let(:user) do
    User.create(
      email: 'danie@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
    )
  end

  let(:other_user) do
    User.create(
      email: 'archive@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
    )
  end

  let(:archived_user) do
    User.create(
      email: 'archive@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
      status: 'archived',
    )
  end

  describe 'POST /create' do
    it 'returns http success' do
      auth_token = authenticate_user(user)
      post user_archive_path(other_user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      other_user.reload
      expect(other_user.status).to eq('archived')
    end

    it 'return error for archiving own user' do
      auth_token = authenticate_user(user)
      post user_archive_path(user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors'].first['detail']).to eq('You cannot perform this action.')
    end
  end

  describe 'POST /delete' do
    it 'returns http success' do
      auth_token = authenticate_user(user)
      delete user_archive_path(archived_user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      archived_user.reload
      expect(archived_user.status).to eq('active')
    end

    it 'return error for unarchiving own user' do
      auth_token = authenticate_user(user)
      delete user_archive_path(user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors'].first['detail']).to eq('You cannot perform this action.')
    end
  end
end
