class AddPendingToBillsHelp < ActiveRecord::Migration
  def change
    add_column :bills_helps, :pending, :integer
  end
end
