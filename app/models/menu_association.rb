# frozen_string_literal: true

# == Schema Information
#
# Table name: menu_associations
#
#  id             :integer          not null, primary key
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :integer          not null
#  menu_item_id   :integer          not null
#
# Indexes
#
#  index_menu_associations_on_menu_id                   (menu_id)
#  index_menu_associations_on_menu_id_and_menu_item_id  (menu_id,menu_item_id) UNIQUE
#  index_menu_associations_on_menu_item_id              (menu_item_id)
#
# Foreign Keys
#
#  menu_id       (menu_id => menus.id)
#  menu_item_id  (menu_item_id => menu_items.id)
#
class MenuAssociation < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :price, presence: true

  monetize :price_cents, allow_nil: false,
                         numericality: { greater_than: 0 }
end
