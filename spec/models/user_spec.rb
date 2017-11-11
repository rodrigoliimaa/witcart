require 'rails_helper'

RSpec.describe User, type: :model do
    before :each do
        @user = FactoryBot::build(:user_joao)
    end

    describe "test support" do
        it "Should create a user using factory bot" do
            expect(@user).to_not be_nil
        end
    end

    describe "validations" do
        it "should pass with default values" do
            expect(@user.valid?).to eq(true)
        end

        it "Should require a name" do
            @user.name = nil
            expect(@user.valid?).to eq(false)
        end
    end
end
