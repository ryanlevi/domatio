class ChangeBillUsersToIntegers < ActiveRecord::Migration
  def up
      change_column :bills, :owner, :integer
      change_column :bills_help, :user, :integer
  end
end
