# frozen_string_literal: true

require 'rails_helper'

describe MenuImport::Strategies::JsonStrategy, :unit do
  let(:file_path) { Rails.root.join('spec/support/menu_import/file.json') }
  let(:restaurant_id) { 1 }
  let(:strategy) { described_class.new(file_path) }

  describe '#import' do
    it 'imports the menu' do
      expect { strategy.import }.to change(MenuItem, :count).by(6)
      expect { strategy.import }.to change(Menu, :count).by(4)
      expect { strategy.import }.to change(Restaurant, :count).by(2)
    end

    it 'imports the restaurants with correct data' do
      strategy.import

      expect(Restaurant.first.name).to eq('Poppo\'s Cafe')
      expect(Restaurant.last.name).to eq('Casa del Poppo')
    end

    it 'imports the menus with correct data' do
      strategy.import

      expect(Menu.first.name).to eq('lunch')
      expect(Menu.last.name).to eq('dinner')
    end

    it 'imports the menu items with correct data' do
      strategy.import

      expect(MenuItem.first.name).to eq('Burger')
      expect(MenuItem.first.price).to eq(Money.new(900))

      expect(MenuItem.last.name).to eq('Lobster Mac & Cheese')
      expect(MenuItem.last.price).to eq(Money.new(3100))
    end
  end
end
