# frozen_string_literal: true

class MenuImport::Strategies::JsonStrategy < MenuImport::Strategies::BaseStrategy
  def import
    ActiveRecord::Base.transaction do
      restaurants.each do |restaurant|
        restaurant_record = Restaurant.create(name: restaurant[:name])

        menus(restaurant).each do |menu|
          menu_record = Menu.create(name: menu[:name], restaurant: restaurant_record)

          menu_items(menu).each do |menu_item|
            MenuItem.create(name: menu_item[:name], price: menu_item[:price], menu: menu_record)
          end
        end
      end
    end
  end

  private

  def parsed_data
    @parsed_data ||= JSON.parse(file_content, symbolize_names: true)
  end

  def restaurants
    @restaurants ||= parsed_data[:restaurants]
  end

  def menus(restaurant)
    restaurant[:menus] || []
  end

  def menu_items(menu)
    menu[:menu_items] || menu[:dishes] || []
  end
end
