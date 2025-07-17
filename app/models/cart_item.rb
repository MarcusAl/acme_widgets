class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :product_id, uniqueness: { scope: :cart_id }

  def total_price_cents
    quantity * product.price_cents
  end

  def total_price_formatted
    Money.new(total_price_cents, "USD").format
  end
end
