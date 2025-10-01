# frozen_string_literal: true

# == Schema Information
#
# Table name: menus
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Menu < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 1000 }

  has_many :menu_items, dependent: :destroy
end
