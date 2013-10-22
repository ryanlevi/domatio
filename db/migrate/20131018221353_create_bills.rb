class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :name
      t.string :owner
      t.string :groupid
      t.integer :price

      t.timestamps
    end
  end
end
