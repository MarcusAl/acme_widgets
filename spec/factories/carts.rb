# == Schema Information
#
# Table name: carts
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :cart do
    trait :with_items do
      after(:create) do |cart|
        cart.products << create(:product)
      end
    end
  end
end
