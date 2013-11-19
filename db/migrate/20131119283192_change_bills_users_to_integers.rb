class ChangeBillsUsersToIntegers < ActiveRecord::Migration
  def up
      change_column :bills, :owner, :integer
  end
end
