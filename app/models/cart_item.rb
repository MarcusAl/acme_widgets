# == Schema Information
#
# Table name: cart_items
#
#  id         :uuid             not null, primary key
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cart_id    :uuid             not null
#  product_id :uuid             not null
#
# Indexes
#
#  index_cart_items_on_cart_id                 (cart_id)
#  index_cart_items_on_cart_id_and_product_id  (cart_id,product_id) UNIQUE
#  index_cart_items_on_product_id              (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#  fk_rails_...  (product_id => products.id)
#
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
