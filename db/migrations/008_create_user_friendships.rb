class CreateUserFriendShips < Sequel::Migration
  def up
    create_table :user_friendships do
      forgeign_key :user_id,
        :table => :users,
        :null => false
      forgeign_key :friend_id,
        :table => :users,
        :null => false
      primary_key [:user_id, :friend_id]
    end
  end

  def down
    drop_table :user_friendships
  end
end

