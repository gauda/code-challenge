require 'swagger_helper'

RSpec.describe 'api/users', type: :request do
  path '/users' do
    get 'Get users' do
      security [ api_key: [] ]

      tags 'Users'
      consumes 'application/json'
      parameter name: :filter, in: :query, allowEmptyValue: true, schema: {
        type: :string,
        enum: %w[active archived]
      }

      response '200', 'users found' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'foo', password_confirmation: 'foo') }
        let(:Authentication) { 'Bearer ' + JwtAuthenticationService.encode_token({ user_id: user.id }) }
        let(:filter) {'active'}
        run_test!
      end
    end
  end

  path '/users/{id}' do
    delete 'Deletes a user' do
      security [ api_key: [] ]

      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user deleted' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'foo', password_confirmation: 'foo') }
        let(:Authentication) { 'Bearer ' + JwtAuthenticationService.encode_token({ user_id: user.id }) }
        let(:id) { User.create(email: 'foo@bar.com', password: 'foo', password_confirmation: 'foo').id }
        run_test!
      end

      response '404', 'user not found' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'foo', password_confirmation: 'foo') }
        let(:Authentication) { 'Bearer ' + JwtAuthenticationService.encode_token({ user_id: user.id }) }
        let(:id) { 'invalid' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { User.create!(email: 'admin@bar.com', password: 'foo', password_confirmation: 'foo') }
        let(:Authentication) { 'Bearer ' + JwtAuthenticationService.encode_token({ user_id: user.id }) }
        let(:id) { user.id }
        run_test!
      end
    end
  end
end
