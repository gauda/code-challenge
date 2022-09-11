require 'swagger_helper'

RSpec.describe 'api/archives', type: :request do
  path '/users/{id}/archive' do
    post 'Archives a user' do
      security [ api_key: [] ]

      tags 'Archive'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '201', 'user archived' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'supersecurepassword', password_confirmation: 'supersecurepassword') }
        let(:Authentication) { "Bearer #{authenticate_user(user)}" }
        let(:id) { User.create!(email: 'foo@bar.com', password: 'foo', password_confirmation: 'foo', status: 'archived').id }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'supersecurepassword', password_confirmation: 'supersecurepassword') }
        let(:Authentication) { "Bearer #{authenticate_user(user)}" }
        let(:id) { user.id }
        run_test!
      end
    end
  end

  path '/users/{id}/archive' do
    delete 'Unarchives a user' do
      security [ api_key: [] ]

      tags 'Archive'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user unarchived' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'supersecurepassword', password_confirmation: 'supersecurepassword') }
        let(:Authentication) { "Bearer #{authenticate_user(user)}" }
        let(:id) { User.create!(email: 'foo@bar.com', password: 'supersecurepassword', password_confirmation: 'supersecurepassword', status: 'active').id }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'supersecurepassword', password_confirmation: 'supersecurepassword') }
        let(:Authentication) { "Bearer #{authenticate_user(user)}" }
        let(:id) { user.id }
        run_test!
      end
    end
  end
end
