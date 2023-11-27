class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :status
      t.float :total_price

      t.timestamps
    end
  end
end
