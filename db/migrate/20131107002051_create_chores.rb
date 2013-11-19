class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :name
      t.string :groupid
      t.datetime :time
      t.integer :recurrence

      t.timestamps
    end
  end
end
