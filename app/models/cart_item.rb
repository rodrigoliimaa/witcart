class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  after_save :update_cart
  before_save :set_price

  validates_presence_of :price, :amount

  default_scope { where('cart_items.updated_at > ?', 2.days.ago) }

  OPERATION = {
    add: "Add",
    subtract: "Subtract"
  }

  # Updates cart timestamps to expire the cart after 2 days
  def update_cart
    self.cart.touch
  end

  def set_price
    self.price = self.product.price * amount
  end

  def self.products_overral
    joins(:product).group('products.name').pluck('products.name, sum(cart_items.amount), sum(cart_items.price)')
  end

  def self.total_pending
    all.sum(&:price)
  end

end
