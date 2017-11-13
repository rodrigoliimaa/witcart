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

    # Specs for the wit test
    describe 'Diogo is preparing a workshop and will buy some books' do
        before :each do
            @product_learn_ror = FactoryBot::build(:product_learn_ror)
            @product_mastering_ror = FactoryBot::build(:product_mastering_ror)
        end
        let(:cart_service) {CartService.new}

        context "he will be adding some books into the cart" do
            it "should add books and tell amount to pay" do
                
                ## Begin Diogo ##

                # Using timecop to simulate diogo's time
                Timecop.travel(1.day.ago)

                # User Diogo
                diogo = FactoryBot::build(:user_diogo)

                # His cart
                cart_diogo = FactoryBot::build(:cart, user: diogo)

                # Adding books 10 books of Learn Ror - Beginner
                cart_service.add_item(cart_diogo, @product_learn_ror, 10)

                # Adding book 1 Mastering RoR - Level over 900
                cart_service.add_item(cart_diogo, @product_mastering_ror, 1)

                # return to the current time
                Timecop.return

                # Adding more 2 books of Learn Ror - Beginner
                cart_service.add_item(cart_diogo, @product_learn_ror, 10)

                expect(cart_diogo.cart_items.size).to eq(2)

                ## End Diogo ##

                ## Begin João ##

                # User João
                joao = FactoryBot::build(:user_joao)

                # His cart
                cart_joao = FactoryBot::build(:cart, user: joao)

                # Adding books 10 books of Learn Ror - Beginner
                cart_service.add_item(cart_joao, @product_mastering_ror, 2)

                ## End João ##

                p "============= Answers for the test =============="
                p "What is the total that Diogo will have to pay?"
                p ActionController::Base.helpers.number_to_currency(cart_service.total(cart_diogo))

                p "What products and respective quantities has Diogo in his cart?"
                cart_diogo.cart_items.each do |cart_item|
                    p "Product: #{cart_item.product.name} Amount: #{cart_item.amount} Total: #{ActionController::Base.helpers.number_to_currency(cart_item.price)}"
                end

                p "How many products are overall in your Cart system?"
                cart_service.products_overral_system.each do |overall|
                    p "Product: #{overall[0]} Amount: #{overall[1]} Total: #{ActionController::Base.helpers.number_to_currency(overall[2])}"
                end

                p "What is the total amount of money that you have pending on your system?"
                p ActionController::Base.helpers.number_to_currency(cart_service.total_pending_system)
            end
        end
    end
end
