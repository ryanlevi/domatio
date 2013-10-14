class CreateDiscussionMessages < ActiveRecord::Migration
  def change
    create_table :discussion_messages do |t|

      t.timestamps
    end
  end
end
