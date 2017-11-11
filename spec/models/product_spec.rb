require 'rails_helper'

RSpec.describe Product, type: :model do
  before :each do
    @product = FactoryBot::build(:product_learn_ror)
  end

  describe "test support" do
    it "Should create a product using factory bot" do
      expect(@product).to_not be_nil
    end
  end

  describe "validations" do
    it "Should require a name" do
      @product.name = nil
      expect(@product.valid?).to eq(false)
    end

    it "Should require a price" do
      @product.price = nil
      expect(@product.valid?).to eq(false)
    end
  end

end
