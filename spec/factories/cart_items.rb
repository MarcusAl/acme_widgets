# == Schema Information
#
# Table name: cart_items
#
#  id         :uuid             not null, primary key
#  quantity   :integer          default(0), not null
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
FactoryBot.define do
  factory :cart_item do
    association :cart
    association :product
    quantity { 1 }
  end
end
