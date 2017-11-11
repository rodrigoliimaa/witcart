class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false
      t.decimal :price, null: false, default: 0
      t.integer :amount, null: false, default: 1

      t.timestamps
    end
  end
end
