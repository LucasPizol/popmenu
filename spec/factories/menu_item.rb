# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    name { Faker::Lorem.word }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end
