require 'rails_helper'

RSpec.describe SpecialOffers, type: :model do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  context 'when a cart has a special offer' do
    before do
      cart.add_item(product.code)
      cart.add_item(product.code)
    end

    it 'returns the special offers discount' do
      expect(cart.special_offers_discount).to eq(product.price_cents / 2)
    end
  end

  context 'when a cart has no special offers' do
    before do
      cart.clear
    end

    it 'returns 0' do
      expect(cart.special_offers_discount).to eq(0)
    end
  end
end
