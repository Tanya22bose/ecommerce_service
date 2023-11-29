class CreateLineItems < ActiveRecord::Migration[7.1]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :product_id
      t.integer :quantity
      t.float :price

      t.timestamps
    end
  end
end
