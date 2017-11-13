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

    def total(cart)
        cart.cart_items.sum(&:price)
    end

    def products_overral_system
        CartItem.products_overral
    end

    def total_pending_system
        CartItem.total_pending
    end

    private
        def update_or_add_cart_item(cart, product, amount)
            cart_item = check_product_exists_in_card(cart, product)
            if cart_item.present?
                check_pricing_change(cart_item, product)
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

        def check_pricing_change(cart_item, product)
            current_price = product.price * cart_item.amount
            raise CartError.new("Product price has changed") if current_price != cart_item.price
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