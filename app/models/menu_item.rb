# frozen_string_literal: true

# == Schema Information
#
# Table name: menu_items
#
#  id             :integer          not null, primary key
#  name           :string
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :integer          not null
#
# Indexes
#
#  index_menu_items_on_menu_id  (menu_id)
#
# Foreign Keys
#
#  menu_id  (menu_id => menus.id)
#
class MenuItem < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true

  monetize :price_cents, allow_nil: false,
                         numericality: { greater_than: 0 }

  belongs_to :menu
end
