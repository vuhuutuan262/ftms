class AddChatworkIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :chatwork_id, :integer
    add_column :course_subjects, :chatwork_room_id, :integer
  end
end
