class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  after_save :update_cart

  validates_presence_of :price, :amount

  OPERATION = {
    add: "Add",
    subtract: "Subtract"
  }

  # Updates cart timestamps to expire the cart after 2 days
  def update_cart
    self.cart.touch
  end

end
