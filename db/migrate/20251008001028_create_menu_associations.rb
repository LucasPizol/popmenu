class CreateMenuAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_associations do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.monetize :price

      t.timestamps

      t.index [ :menu_id, :menu_item_id ], unique: true
    end
  end
end
