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
class Product < ApplicationRecord
  PRODUCT_CODES = %w[R01 G01 B01]

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :code, presence: true, inclusion: { in: PRODUCT_CODES }, uniqueness: true

  monetize :price_cents, as: :price

  def price_formatted
    Money.new(price_cents, "USD").format
  end
end
