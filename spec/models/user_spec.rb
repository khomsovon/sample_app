require 'rails_helper'

RSpec.describe User, type: :model do

  context "Validation" do
    it "ensures first name presence" do

      user = User.new(last_name: "khom", email: "khom@gmail.com").save
      expect(user).to eq(false)

    end

    it "ensures last name presence" do

      user = User.new(first_name: "sovon", email: "sovon@gmail.com").save
      expect(user).to eq(false)

    end

    it "ensures email presence" do

      user = User.new(first_name: "sovon", last_name: "khom").save
      expect(user).to eq(false)

    end

    it "should save successfully" do

      user = User.new(first_name: "sovon", last_name: "khom", email: "sovon.khom@gmail.com", password: "123456Kc").save
      expect(user).to eq(true)

    end
  end

  context "Scope tests" do

    let (:params) { {first_name: "sovon", last_name: "khom", password: "123456Kc"} }

    before(:each) do
      User.new(params.merge(email: "sovon.khom1@gmail.com")).save
      User.new(params.merge(email: "sovon.khom2@gmail.com")).save
      User.new(params.merge(active: true, email: "sovon.khom3@gmail.com")).save
      User.new(params.merge(active: false, email: "sovon.khom4@gmail.com")).save
      User.new(params.merge(active: false, email: "sovon.khom5@gmail.com")).save
    end

    it "should return active users" do
      expect(User.active_users.size).to eq(3)
    end

    it "should return inactive users" do
      expect(User.inactive_users.size).to eq(2)
    end
  end

end
