# frozen_string_literal: true

FactoryBot.define do
  factory :menu_association do
    menu { create(:menu) }
    menu_item { create(:menu_item) }
    price { 100 }
  end
end
