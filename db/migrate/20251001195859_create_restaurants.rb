# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
