require 'rails_helper'

RSpec.describe CartItem, type: :model do

  before :each do
    @cart_item = FactoryBot::build(:cart_item, cart: FactoryBot::build(:cart), product: FactoryBot::build(:product_learn_ror))
  end

  describe "test support" do
    it "should create a cart item using factory bot" do
      expect(@cart_item).to_not be_nil
    end
  end

  describe "Validations" do
    it "should pass with default values" do
      expect(@cart_item.valid?).to eq(true)
    end

    it "Should require a cart" do
      @cart_item.cart = nil
      expect(@cart_item.valid?).to eq(false)
    end

    it "Should require a product" do
      @cart_item.product = nil
      expect(@cart_item.valid?).to eq(false)
    end

    it "Should require a amount" do
      @cart_item.amount = nil
      expect(@cart_item.valid?).to eq(false)
    end

    it "Should require a price" do
      @cart_item.price = nil
      expect(@cart_item.valid?).to eq(false)
    end

  end

end
