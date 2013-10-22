class AddDuedateToBills < ActiveRecord::Migration
  def change
    add_column :bills, :duedate, :datetime
  end
end
