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

  def save_menu_item(menu_item_json, menu_record)
    menu_item_record = MenuItem.new(name: menu_item_json[:name], price: menu_item_json[:price], menu: menu_record)

    menu_import_log = menu_item_record.save ? MenuImport::Log.new(status: :success, message: "Menu item created: #{menu_item_json[:name]}") :
                                              MenuImport::Log.new(status: :error, message: "Menu item not created: #{menu_item_json[:name]}", errors: menu_item_record.errors.full_messages)

    logs << menu_import_log
  end

  def file_content
    @file_content ||= File.read(file_path)
  end
end
