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
require "rails_helper"

describe MenuItem, :unit, type: :model do
  let_it_be(:restaurant) { create(:restaurant) }
  subject(:menu_item) { build(:menu_item, restaurant: restaurant) }

  describe 'validations' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:restaurant) }
    it { is_expected.to have_many(:menu_associations) }
    it { is_expected.to have_many(:menus).through(:menu_associations) }
  end
end
