# == Schema Information
#
# Table name: products
#
#  id          :uuid             not null, primary key
#  code        :string
#  name        :string
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_code  (code) UNIQUE
#
FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    code { Product::PRODUCT_CODES.sample }
    price_cents { Faker::Number.between(from: 100, to: 10000) }
  end
end
