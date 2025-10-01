# frozen_string_literal: true

# == Schema Information
#
# Table name: menu_items
#
#  id             :integer          not null, primary key
#  name           :string
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :integer          not null
#
# Indexes
#
#  index_menu_items_on_menu_id  (menu_id)
#
# Foreign Keys
#
#  menu_id  (menu_id => menus.id)
#
require "rails_helper"

describe MenuItem, :unit, type: :model do
  let_it_be(:menu) { create(:menu) }

  describe 'validations' do
    subject(:menu_item) { build(:menu_item, menu: menu) }

    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:menu) }
  end

  describe "monetize price" do
    let(:menu_item) { build(:menu_item, price: price, menu: menu) }
    let(:price) { 12.34 }

    context 'when price is valid' do
      it "should be a Money object" do
        expect(menu_item.price).to be_a(Money)
      end

      it "should persist the cents in price_cents when assigning a number" do
        expect(menu_item.price_cents).to eq(1234)
        expect(menu_item.price_currency).to eq("USD")
      end
    end

    context 'when price is invalid' do
      context 'when price is zero' do
        let(:price) { 0 }

        it "should be invalid" do
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:price]).to be_present
        end
      end

      context 'when price is negative' do
        let(:price) { -1 }

        it "should be invalid" do
          expect(menu_item).not_to be_valid
          expect(menu_item.errors[:price]).to be_present
        end
      end
    end
  end
end
