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
require "rails_helper"

describe Menu, :unit, type: :model do
  subject(:menu) { build(:menu) }

  describe 'validations' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:menu_items).dependent(:destroy) }
    it { is_expected.to belong_to(:restaurant) }
  end
end
