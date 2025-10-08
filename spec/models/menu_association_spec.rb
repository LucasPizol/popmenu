# == Schema Information
#
# Table name: menu_associations
#
#  id             :integer          not null, primary key
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  menu_id        :integer          not null
#  menu_item_id   :integer          not null
#
# Indexes
#
#  index_menu_associations_on_menu_id                   (menu_id)
#  index_menu_associations_on_menu_id_and_menu_item_id  (menu_id,menu_item_id) UNIQUE
#  index_menu_associations_on_menu_item_id              (menu_item_id)
#
# Foreign Keys
#
#  menu_id       (menu_id => menus.id)
#  menu_item_id  (menu_item_id => menu_items.id)
#
require "rails_helper"

describe MenuAssociation, :unit, type: :model do
  let_it_be(:restaurant) { create(:restaurant) }
  let_it_be(:menu) { create(:menu) }
  let_it_be(:menu_item) { create(:menu_item, restaurant: restaurant) }

  describe "associations" do
    it { is_expected.to belong_to(:menu) }
    it { is_expected.to belong_to(:menu_item) }
  end

  describe "monetize price" do
    subject(:menu_association) { build(:menu_association, price: price, menu: menu, menu_item: menu_item) }
    let(:price) { 12.34 }

    context 'when price is valid' do
      it "should be a Money object" do
        expect(menu_association.price).to be_a(Money)
      end

      it "should persist the cents in price_cents when assigning a number" do
        expect(menu_association.price_cents).to eq(1234)
        expect(menu_association.price_currency).to eq("USD")
      end
    end

    context 'when price is invalid' do
      context 'when price is zero' do
        let(:price) { 0 }

        it "should be invalid" do
          expect(menu_association).not_to be_valid
          expect(menu_association.errors[:price]).to be_present
        end
      end

      context 'when price is negative' do
        let(:price) { -1 }

        it "should be invalid" do
          expect(menu_association).not_to be_valid
          expect(menu_association.errors[:price]).to be_present
        end
      end
    end
  end
end
