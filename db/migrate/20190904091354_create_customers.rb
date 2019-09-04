class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.text :description
      t.boolean :blacklist

      t.timestamps
    end
  end
end
