class Product < ApplicationRecord
  PRODUCT_CODES = %w[R01 G01 B01]

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :code, presence: true, inclusion: { in: PRODUCT_CODES }, uniqueness: true

  monetize :price_cents, as: :price
end
