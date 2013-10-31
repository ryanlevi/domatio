class CreateBillsHelps < ActiveRecord::Migration
  def change
    create_table :bills_helps do |t|
      t.integer :bill_id
      t.string :user
      t.decimal :amount

      t.timestamps
    end
  end
end
