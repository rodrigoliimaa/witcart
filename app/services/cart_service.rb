class CartError < StandardError; end

class CartService

    def add_item(cart, product, amount)
        check_product(product)
        check_amount(amount)
        update_or_add_cart_item(cart, product, amount)
    end

    # Remove CartItem, can be used to remove the entire item or an specific amount
    def remove_item(cart, product, amount)
        check_product(product)
        check_amount(amount)
        update_or_delete_cart_item(cart, product, amount)
    end

    private
        def update_or_add_cart_item(cart, product, amount)
            cart_item = check_product_exists_in_card(cart, product)
            if cart_item.present?
                update_cart_item(cart_item, amount, CartItem::OPERATION[:add])
            else
                CartItem.create({cart: cart, product: product, amount: amount})
            end
        end

        def update_or_delete_cart_item(cart, product, amount)
            cart_item = check_product_exists_in_card(cart, product)
            if cart_item.present?
                if cart_item.amount <= amount
                    cart_item.destroy
                else
                    update_cart_item(cart_item, amount, CartItem::OPERATION[:subtract])
                end
            end
        end

        def update_cart_item(cart_item, amount, operation)
            new_amount = operation == CartItem::OPERATION[:add] ? cart_item.amount + amount : cart_item.amount - amount
            cart_item.update({amount: new_amount})
        end

        def check_product_exists_in_card(cart, product)
            cart.get_cart_item_in_cart(product)
        end

        def check_product(product)
            raise CartError.new("Invalid Product") if product.blank?
        end

        def check_amount(amount)
            raise CartError.new("Invalid Amount") if amount <= 0
        end

end