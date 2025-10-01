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
  end
end
