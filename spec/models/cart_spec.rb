require 'rails_helper'

RSpec.describe Cart, type: :model do
  before :each do
    @cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
  end

  describe "test support" do
    it "should create a cart using factory bot" do
      expect(@cart).to_not be_nil
    end
  end

  describe "Validations" do
    it "should pass with default values" do
      expect(@cart.valid?).to eq(true)
    end

    it "Should require a user" do
      @cart.user = nil
      expect(@cart.valid?).to eq(false)
    end

    it "Should be expired after 2 days" do
      @cart.updated_at = 2.days.ago
      expect(@cart.valid?).to eq(false)
    end
  end

end
