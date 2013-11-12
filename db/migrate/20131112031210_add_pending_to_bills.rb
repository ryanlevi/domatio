class AddPendingToBills < ActiveRecord::Migration
  def change
    add_column :bills, :pending, :integer
  end
end
