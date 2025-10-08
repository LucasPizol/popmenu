class RemovePriceAndFixRelationsOfMenuItem < ActiveRecord::Migration[8.0]
  def up
    change_table :menu_items do |t|
      t.remove :price_cents
      t.remove :price_currency
      t.remove :menu_id

      t.references :restaurant, null: false, foreign_key: true
    end
  end

  def down
    change_table :menu_items do |t|
      t.monetize :price
      t.references :menu, null: false, foreign_key: true

      t.remove :restaurant_id
    end
  end
end
