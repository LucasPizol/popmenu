# frozen_string_literal: true

# == Schema Information
#
# Table name: menu_items
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :integer          not null
#
# Indexes
#
#  index_menu_items_on_name           (name) UNIQUE
#  index_menu_items_on_restaurant_id  (restaurant_id)
#
# Foreign Keys
#
#  restaurant_id  (restaurant_id => restaurants.id)
#
class MenuItem < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :restaurant
  has_many :menu_associations, dependent: :destroy
  has_many :menus, through: :menu_associations
end
