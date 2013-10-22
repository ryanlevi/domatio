class CreateDiscussion < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :user_id
      t.timestamps
      t.string :title
      t.integer :messages_count
    end
  end
end
