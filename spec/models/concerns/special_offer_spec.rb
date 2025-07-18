require 'rails_helper'

RSpec.describe SpecialOffers, type: :concern do
  let(:product) { create(:product, code: Product::PRODUCT_CODES.first) }
  let(:cart) { create(:cart) }

  context 'when a cart has items that qualify for a special offer' do
    it 'returns the special offers discount' do
      cart.add_item(product.code)
      cart.add_item(product.code)
      expect(cart.special_offers_discount).to eq(product.price_cents / 2)
      expect(cart.special_offers_discount_formatted).to eq(Money.new(product.price_cents / 2, "USD").format)
    end
  end

  context 'when a cart has items that do not qualify for a special offer' do
    let(:product) { create(:product, code: Product::PRODUCT_CODES.last) }
    let(:cart) { create(:cart) }

    it 'returns 0' do
      expect(cart.special_offers_discount).to eq(0)
    end
  end
end
