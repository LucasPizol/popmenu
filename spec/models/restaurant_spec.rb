# frozen_string_literal: true

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
require "rails_helper"

describe Restaurant, :unit, type: :model do
  subject(:restaurant) { build(:restaurant) }

  describe 'validations' do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:description).is_at_most(1000) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:menus).dependent(:destroy) }
    it { is_expected.to have_many(:menu_associations).through(:menus) }
    it { is_expected.to have_many(:menu_items) }
  end
end
