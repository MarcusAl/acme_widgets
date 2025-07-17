# == Schema Information
#
# Table name: carts
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Cart < ApplicationRecord
  include DeliveryCharges
  include SpecialOffers

  CartError = Class.new(StandardError)

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_item(product_code, quantity = 1)
    product = find_product_by_code(product_code)

    cart_item = cart_items.find_or_initialize_by(product: product)
    cart_item.quantity += quantity
    cart_item.save!
  end

  def remove_item(product_code)
    product = find_product_by_code(product_code)

    cart_items.find_by(product: product)&.destroy
  end

  def update_quantity(product_code, quantity)
    product = find_product_by_code(product_code)

    cart_item = cart_items.find_by(product: product)
    if cart_item
      if quantity > 0
        cart_item.update!(quantity: quantity)
      else
        cart_item.destroy
      end
    end
  end

  def clear
    cart_items.destroy_all
  end

  def empty?
    cart_items.empty?
  end

  def subtotal
    cart_items.sum { |item| item.total_price_cents }
  end

  def total
    subtotal - special_offers_discount + delivery_charge
  end

  def total_formatted
    Money.new(total, "USD").format
  end

  private

  def find_product_by_code(product_code)
    Product.find_by(code: product_code) || (raise CartError, "Product not found: #{product_code}")
  end

  # For DeliveryCharges concern
  def order_total
    subtotal
  end

  # For SpecialOffers concern
  def count_product_quantity(product_code)
    cart_items.joins(:product)
             .where(products: { code: product_code })
             .sum(:quantity)
  end

  def find_product_price(product_code)
    product = products.find_by(code: product_code)
    product&.price_cents || 0
  end
end
