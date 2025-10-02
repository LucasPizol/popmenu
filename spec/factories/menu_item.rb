# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    price { Faker::Number.decimal(l_digits: 2) }
    menu { create(:menu) }
  end
end
