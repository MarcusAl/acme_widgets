# == Schema Information
#
# Table name: carts
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:product) { create(:product) }

  subject { build(:cart) }


  it { is_expected.to be_valid }

  describe 'associations' do
    it { should have_many(:cart_items) }
    it { should have_many(:products).through(:cart_items) }
  end

  before do
    subject.clear
  end

  describe '#add_item' do
    it 'adds an item to the cart' do
      subject.add_item(product.code)
      expect(subject.cart_items.reload.count).to eq(1)
    end
  end

  describe '#remove_item' do
    it 'removes an item from the cart' do
      subject.add_item(product.code)
      expect { subject.remove_item(product.code) }.to change(subject.cart_items, :count).by(-1)
    end
  end

  describe '#update_quantity' do
    it 'updates the quantity of an item in the cart' do
      subject.add_item(product.code)
      subject.update_quantity(product.code, 2)
      expect(subject.cart_items.first.reload.quantity).to eq(2)
    end
  end

  describe '#clear' do
    it 'clears the cart' do
      subject.add_item(product.code)
      expect { subject.clear }.to change(subject.cart_items, :count).to(0)
    end
  end

  describe '#empty?' do
    it 'returns true if the cart is empty' do
      expect(subject.empty?).to be_truthy
    end
  end

  describe '#subtotal' do
    it 'returns the subtotal of the cart' do
      subject.add_item(product.code)
      expect(subject.subtotal).to eq(product.price_cents)
    end
  end

  describe '#total' do
    let(:special_offer_discount) { subject.special_offers_discount }
    let(:delivery_charge) { subject.delivery_charge }

    it 'returns the total of the cart minus delivery charge and special offers discount' do
      subject.add_item(product.code)
      expect(subject.total).to eq(product.price_cents - special_offer_discount + delivery_charge)
    end
  end
end
