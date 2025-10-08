# == Schema Information
#
# Table name: restaurants
#
#  id          :integer          not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 1000 }

  has_many :menu_items, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :menu_associations, dependent: :destroy, through: :menus
end
