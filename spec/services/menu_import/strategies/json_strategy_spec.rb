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

      expect(Restaurant.pluck(:name)).to eq([ "Poppo's Cafe", "Casa del Poppo" ])
    end

    it 'imports the menus with correct data' do
      strategy.import

      expect(Menu.pluck(:name)).to eq(%w[lunch dinner lunch dinner])
    end

    it 'imports the menu items with correct data' do
      strategy.import

      expect(MenuItem.all.map { |item| { name: item.name, price: item.price.format } }).to eq(
        [
          { name: 'Burger', price: "$9.00" },
          { name: 'Small Salad', price: "$5.00" },
          { name: 'Large Salad', price: "$8.00" },
          { name: 'Chicken Wings', price: "$9.00" },
          { name: 'Mega "Burger"', price: "$22.00" },
          { name: 'Lobster Mac & Cheese', price: "$31.00" }
        ])
    end

    it 'imports the logs with correct data' do
      strategy.import

      expect(strategy.logs.count).to eq(9)
      expect(strategy.logs.map(&:to_h)).to eq(
        [
          { errors: nil, message: "Menu item created: Burger", status: "success" },
          { errors: nil, message: "Menu item created: Small Salad", status: "success" },
          { errors: [ "Name has already been taken" ], message: "Menu item not created: Burger", status: "error" },
          { errors: nil, message: "Menu item created: Large Salad", status: "success" },
          { errors: nil, message: "Menu item created: Chicken Wings", status: "success" },
          { errors: [ "Name has already been taken" ], message: "Menu item not created: Burger", status: "error" },
          { errors: [ "Name has already been taken" ], message: "Menu item not created: Chicken Wings", status: "error" },
          { errors: nil, message: "Menu item created: Mega \"Burger\"", status: "success" },
          { errors: nil, message: "Menu item created: Lobster Mac & Cheese", status: "success" }
        ])
    end
  end
end
