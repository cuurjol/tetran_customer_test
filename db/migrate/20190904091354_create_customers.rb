class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.text :description
      t.boolean :blacklist, default: false

      t.timestamps
    end
  end
end
