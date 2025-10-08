# frozen_string_literal: true

require 'rails_helper'

describe MenuImport::Strategies::JsonStrategy, :unit do
  let(:file_path) { Rails.root.join('spec/fixtures/files/menu_import/file.json') }
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

      menu_associations = MenuAssociation.includes(:menu_item).map do |item|
        {
          name: item.menu_item.name,
          price: item.price.format,
          menu_item_id: item.menu_item_id,
          menu_id: item.menu_id,
          restaurant_id: item.menu_item.restaurant_id
        }
      end

      expect(menu_associations).to eq(
        [
          { name: 'Burger', price: "$9.00", menu_item_id: 1, menu_id: 1, restaurant_id: 1 },
          { name: 'Small Salad', price: "$5.00", menu_item_id: 2, menu_id: 1, restaurant_id: 1 },
          { name: 'Burger', price: "$15.00", menu_item_id: 1, menu_id: 2, restaurant_id: 1 },
          { name: 'Large Salad', price: "$8.00", menu_item_id: 3, menu_id: 2, restaurant_id: 1 },
          { name: 'Chicken Wings', price: "$9.00", menu_item_id: 4, menu_id: 3, restaurant_id: 2 },
          { name: 'Mega "Burger"', price: "$22.00", menu_item_id: 5, menu_id: 4, restaurant_id: 2 },
          { name: 'Lobster Mac & Cheese', price: "$31.00", menu_item_id: 6, menu_id: 4, restaurant_id: 2 }
        ])
    end

    it 'imports the logs with correct data' do
      strategy.import

      expect(strategy.logs.count).to eq(9)
      expect(strategy.logs.map(&:to_h)).to eq(
        [
          { errors: nil, message: "Burger created and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Small Salad created and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Burger already exists and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Large Salad created and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Chicken Wings created and was correctly associated to 'lunch'", status: "success" },
          { errors: [ "Name has already been taken" ], message: "Burger not created", status: "error" },
          { errors: nil, message: "Chicken Wings already exists and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Mega \"Burger\" created and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Lobster Mac & Cheese created and was correctly associated to 'dinner'", status: "success" }
        ])
    end
  end
end
