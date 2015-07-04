class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.references :list, index: true, null: false
      t.references :product, index: true, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps null: false
    end
  end
end
