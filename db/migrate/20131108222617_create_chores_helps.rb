class CreateChoresHelps < ActiveRecord::Migration
  def change
    create_table :chores_helps do |t|
      t.integer :chore_id
      t.integer :user_id

      t.timestamps
    end
  end
end
