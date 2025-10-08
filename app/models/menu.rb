# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id            :integer          not null, primary key
#  description   :text
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  restaurant_id :integer          not null
#
# Indexes
#
#  index_menus_on_restaurant_id  (restaurant_id)
#
# Foreign Keys
#
#  restaurant_id  (restaurant_id => restaurants.id)
#
class Menu < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 1000 }

  has_many :menu_associations, dependent: :destroy
  has_many :menu_items, through: :menu_associations
  belongs_to :restaurant
end
