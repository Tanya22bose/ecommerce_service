require 'rails_helper'

# Define shared examples at the beginning of the file
RSpec.shared_examples 'a registration error' do |error_message, extra_params|
  let(:user_count) { 1 }
  it "when #{error_message}" do
    post '/authentications/register', params: attributes_for(:user, :email => 'existing@example.com', password_confirmation: 'password').merge(extra_params)
    expect(User.count).to be(user_count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json_response['errors']).to include(error_message)
  end
end

RSpec.describe 'Authentications', type: :request do
  before do
    create(:user, :email => "alreadytaken@example.com")
  end

  describe 'POST authentications/register' do
    let(:valid_attributes) do
      { email: 'test@example.com', password: 'password', password_confirmation: 'password' }
    end

    context 'with valid parameters' do
      before { post '/authentications/register', params: valid_attributes }

      it 'creates a User, returns a JWT token and returns a success message' do
        expect(User.count).to eq(2)
        expect(User.last.email).to eq(valid_attributes[:email])
        expect(response).to have_http_status(:created)
        expect(json_response['token']).not_to be_nil
        expect(json_response['message']).to eq('User was successfully registered')
      end
    end

    let(:invalid_attributes) do
      valid_attributes.merge(password_confirmation: 'wrong')
    end

    context 'with invalid parameters' do
      it_behaves_like 'a registration error', 'Email has already been taken', email: "alreadytaken@example.com"
      it_behaves_like 'a registration error', "Email can't be blank", email: ''
      it_behaves_like 'a registration error', "Password can't be blank", password: '', password_confirmation: ''
      it_behaves_like 'a registration error', "Password confirmation doesn't match Password", email: 'test@example.com', password_confirmation: "pass"
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@.com'
      it_behaves_like 'a registration error', "Email is invalid", email: 'magesh@gmail#.com'
      it_behaves_like 'a registration error', "Password is too short (minimum is 8 characters)", password: 'short', password_confirmation: 'short'
      it_behaves_like 'a registration error', "Password is too long (maximum is 15 characters)", password: 'itstoolongpassword', password_confirmation: 'itstoolongpassword'
    end
  end

  describe 'POST authentications/login' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          email: "alreadytaken@example.com",
          password: "testpassword",
        }
      end

      before { post '/authentications/login', params: valid_attributes}

      it'returns a JWT token and a success message' do
        expect(response).to have_http_status(:ok)
        expect(json_response['token']).not_to be_nil
        expect(json_response['message']).to eq('User logged in successfully')
      end

    end
    context 'with invalid parameters' do
      
      let(:invalid_attributes) do
        {
          email: "alreadytak@example.com",
          password: "testpassword",
        }
      end

      it 'returns an error message if User doesn\'t exist' do
        post '/authentications/login', params: invalid_attributes
        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to include('Invalid Email or Password')
      end

      it'returns an error message if password is wrong and User exists' do
        post '/authentications/login', params: invalid_attributes.merge(email: "alreadytaken@example.com", :password => 'PASSWORD')
        expect(json_response['error']).to include('Invalid Email or Password')
      end

    end
  end
end