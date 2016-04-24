class AddIndexToEventUsersUserIdEventId < ActiveRecord::Migration
  def change
    add_index :event_users, [:user_id, :event_id], :unique => true
  end
end
