require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  describe 'POST #register' do
  let(:valid_attributes) do 
    {
      email: 'test@example.com',
      password: '<PASSWORD>',
      password_confirmation: '<PASSWORD>',
    }
  end
  
  let(:invalid_attributes) do 
    {
      email: 'test@example.com',
      password: '<PASSWORD>',
      password_confirmation: 'PASSWORD',
    }
  end

  context 'with valid params' do
    before { post :register, params: valid_attributes }
    
    it 'Creates a User' do
      expect(response).to have_http_status(:created)
    end
  end

  context 'with invalid params' do
    before { post :register, params: invalid_attributes }
    
    it 'Does not create a User' do
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to include('application/json')
      expect(response.content_type).to include('charset=utf-8')
    end
  end
end
  
describe 'POST #login' do
 let(:user) { create(:user, email: 'test@gmail.com') }

 context 'with valid credentials' do
  before { post :login, params: { email: user.email , password: 'testpassword' } }
  
  it 'logs in the user' do
    expect(response).to have_http_status(:ok)
    expect(json_response["token"]).to be_present
  end
end

context 'with invalid credentials' do
  before { post :login, params: { email: "xyz@gmail.com" , password: '123'}}

  it 'does not log in the user' do
    expect(response).to have_http_status(:unauthorized)
    expect(json_response["error"]).to include("Invalid Email or Password")
  end
end
end
end
