class CreateFollowedUsers < Sequel::Migration
  def up
    create_table :followed_users do
      foreign_key :user_id,
        :table => :users,
        :null => false
      foreign_key :followed_user_id,
        :table => :users,
        :null => false
      primary_key [:user_id, :followed_user_id]
    end
  end

  def down
    drop_table :followed_users
  end
end

