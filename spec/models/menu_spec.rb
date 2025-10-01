# frozen_string_literal: true

require "rails_helper"

describe Menu, :unit, type: :model do
  subject(:menu) { build(:menu) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:description).is_at_most(1000) }
end
