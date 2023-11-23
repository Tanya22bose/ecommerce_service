require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do 
      user = build(:user, password: "test1234")
      expect(user).to be_valid
    end
    it "is invalid is password is blank" do 
      user = build(:user, password: "")
      expect(user).to be_invalid
    end
    it "is invalid is password is shorter than the min length" do 
      user = build(:user, password: "test123")
      expect(user).to be_invalid
    end
    it "is invalid is password is greater than the max length" do 
      user = build(:user, password: "test123aihflierjbfaeijrbf")
      expect(user).to be_invalid
    end
    it "is invalid if email already exists" do 
      create(:user, email: "test@gmail.com")
      user = build(:user, email: "test@gmail.com")
      expect(user).to be_invalid
    end
    it "is invalid if email is blank" do 
      user = build(:user, email: "")
      expect(user).to be_invalid
    end
    it "is invalid if email is invalid" do 
      user = build(:user, email: "test123456")
      expect(user).to be_invalid
    end
    it "is invalid if email is invalid" do 
      user = build(:user, email: "test@gmail#.com")
      expect(user).to be_invalid
    end
    it "is invalid if password is incorrect and user exists" do
      create(:user, email: "test@gmail.com", password: "<PASSWORD>")
      user = build(:user, email: "test@gmail.com", password: "<PASSWORD")
      expect(user).to be_invalid
    end

  end

  describe "token methods" do
    let(:user) { create(:user) }

    it "encodes the payload and returns a token, decodes the token and return user_id" do 
      payload = {user_id: user.id}
      token = User.encode_token(payload);
      expect(token).not_to be_nil

      decoded_token = User.decode_token(token)
      expect(decoded_token["user_id"]).to eq(user.id)
    end
  end
end
