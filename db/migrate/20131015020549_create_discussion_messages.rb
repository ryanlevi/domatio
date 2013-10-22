class CreateDiscussionMessages < ActiveRecord::Migration
  def change
    create_table :discussion_messages do |t|
      t.integer :user_id
      t.text :content
      t.integer :discussion_id
      t.timestamps
    end
  end
end
