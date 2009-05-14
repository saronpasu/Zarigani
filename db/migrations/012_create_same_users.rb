class SameUsers < Sequel::Migration
  def up
    create_table :user_same_users do
      foreign_key :user_id,
        :table => :users,
        :null => false
      foreign_key :same_user_id,
        :table => :users,
        :null => false
      primary_key [:user_id, :same_user_id]
    end
  end

  def down
    drop_table :user_same_users
  end
end

