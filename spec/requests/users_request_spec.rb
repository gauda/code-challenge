require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) do
    User.create(
      email: 'danie@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
      status: 'active'
    )
  end

  let(:archived_user) do
    User.create(
      email: 'archived_1@example.com',
      password: 'supersecurepassword',
      password_confirmation: 'supersecurepassword',
      status: 'archived'
    )
  end

  describe 'GET /index' do
    before do
      User.create(
        email: 'active_1@example.com',
        password: 'supersecurepassword',
        password_confirmation: 'supersecurepassword',
        status: 'active'
      )
      User.create(
        email: 'active_2@example.com',
        password: 'supersecurepassword',
        password_confirmation: 'supersecurepassword',
        status: 'active'
      )
      User.create(
        email: 'archived_2@example.com',
        password: 'supersecurepassword',
        password_confirmation: 'supersecurepassword',
        status: 'archived'
      )
    end

    it 'returns http success' do
      auth_token = authenticate_user(user)
      get users_path, headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['data'].count).to eq(4)
    end

    it 'returns http success based on query "active"' do
      auth_token = authenticate_user(user)
      get users_path(q: {status_eq: :active}), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['data'].count).to eq(3)
    end

    it 'returns http success based on query "archived"' do
      auth_token = authenticate_user(user)
      get users_path(q: {status_eq: :archived}), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['data'].count).to eq(1)
    end
  end

  describe 'POST /delete' do
    it 'returns http success' do
      auth_token = authenticate_user(user)
      delete user_path(archived_user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(:success)

      expect { archived_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'return error for deleting own user' do
      auth_token = authenticate_user(user)
      delete user_path(user), headers: { 'Authentication' => "Bearer #{auth_token}" }
      expect(response).to have_http_status(422)
    end
  end
end
