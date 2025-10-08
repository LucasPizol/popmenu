# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    restaurant { create(:restaurant) }
  end
end
