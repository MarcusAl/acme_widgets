class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name
      t.string :code
      t.integer :price_cents

      t.timestamps
    end

    add_index :products, :code, unique: true
  end
end
