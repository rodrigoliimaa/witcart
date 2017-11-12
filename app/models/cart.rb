class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  # The cart should be expired after 2 days
  default_scope { where('updated_at > ?', 2.days.ago) }
  validate :check_expiration_date

  def get_cart_item_in_cart(product)
    cart_items.where(product_id: product.id).first
  end

  private
    def check_expiration_date
      errors.add(:updated_at, "Cart expired") if updated_at.present? && updated_at < 2.days.ago
    end

end
