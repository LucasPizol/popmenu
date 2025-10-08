# frozen_string_literal: true

class MenuImport::Strategies::BaseStrategy
  def initialize(file_path)
    @file_path = file_path
    @logs = []
  end

  def import
    raise NotImplementedError
  end

  attr_reader :file_path, :logs

  protected

  def save_menu_item(menu_item_json, menu_record, restaurant_record)
    menu_item_record = restaurant_record.menu_items.where("lower(name) = ?", menu_item_json[:name].downcase).first

    if menu_item_record.blank?
      menu_item_record = MenuItem.create!(name: menu_item_json[:name], restaurant: restaurant_record)
    end

    menu_association_record = MenuAssociation.find_or_initialize_by(menu: menu_record, menu_item: menu_item_record)

    menu_association_record.price = menu_item_json[:price]
    menu_association_record.save!

    logs << MenuImport::Log.new(status: :success, message: "Menu item created: #{menu_item_json[:name]}")
  rescue ActiveRecord::RecordInvalid => e
    logs << MenuImport::Log.new(status: :error, message: "Menu item not created: #{menu_item_json[:name]}", errors: e.record.errors.full_messages)
  end

  def file_content
    @file_content ||= File.read(file_path)
  end
end
