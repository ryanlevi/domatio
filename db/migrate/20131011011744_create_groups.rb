class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :groupname
      t.string :groupid

      t.timestamps
    end
  end
end
