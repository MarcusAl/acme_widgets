# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

products_data = [
  {
    name: "Red Widget",
    code: "R01",
    price_cents: 3295
  },
  {
    name: "Green Widget",
    code: "G01",
    price_cents: 2495
  },
  {
    name: "Blue Widget",
    code: "B01",
    price_cents: 795
  }
]

products_data.each do |product_hsh|
  Product.find_or_create_by!(code: product_hsh[:code]) do |product|
    product.name = product_hsh[:name]
    product.price_cents = product_hsh[:price_cents]
  end
end

puts "Created #{Product.count} products"
