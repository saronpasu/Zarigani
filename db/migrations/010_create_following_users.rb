class CreateFollowingUsers < Sequel::Migration
  def up
    create_table :following_users do
      foreign_key :user_id,
        :table => :users,
        :null => false
      foreign_key :following_user_id,
        :table => :users,
        :null => false
      primary_key [:user_id, :following_user_id]
    end
  end

  def down
    drop_table :following_users
  end
end

