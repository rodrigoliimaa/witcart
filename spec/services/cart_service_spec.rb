require 'rails_helper'

RSpec.describe CartService do

    describe 'Using the cart' do
        let(:cart_service) {CartService.new}

        context "Adding item into the cart" do
            it "It should validate if try to add an nil product" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = nil
                amount = 1

                expect {cart_service.add_item(cart, product, amount)}.to raise_error(CartError)
            end

            it "It should validate if try to add an invalid amount" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = -1
                
                expect {cart_service.add_item(cart, product, amount)}.to raise_error(CartError)
            end

            it "It should add items" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = 1

                cart_service.add_item(cart, product, amount)

                expect(cart.cart_items.size).to eq(1)
            end
            
            it "It should sum if add the same product" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = 1

                cart_service.add_item(cart, product, amount)
                cart_service.add_item(cart, product, amount)
                
                expect(cart.cart_items.size).to eq(1)
                expect(cart.cart_items[0].amount).to eq(2)
            end
        end

        context "Removing item from the cart" do
            it "It should validate if try to remove an nil product" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = nil
                amount = 1

                expect {cart_service.remove_item(cart, product, amount)}.to raise_error(CartError)
            end

            it "It should validate if try to remove an invalid amount" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = -1
                
                expect {cart_service.remove_item(cart, product, amount)}.to raise_error(CartError)
            end

            it "It should remove items" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = 1

                cart_service.add_item(cart, product, amount)
                cart_service.remove_item(cart, product, amount)

                expect(cart.cart_items.size).to eq(0)
            end

            it "It should remove items partially" do
                cart = FactoryBot::build(:cart, user: FactoryBot::build(:user_joao))
                product = FactoryBot::build(:product_learn_ror)
                amount = 10
                remove_amount = 5

                cart_service.add_item(cart, product, amount)
                cart_service.remove_item(cart, product, remove_amount)

                expect(cart.cart_items.size).to eq(1)
                expect(cart.cart_items[0].amount).to eq(5)
            end
        end

    end
end
