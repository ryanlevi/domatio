class AddRecurringToBills < ActiveRecord::Migration
  def change
    add_column :bills, :recurring, :integer
  end
end
