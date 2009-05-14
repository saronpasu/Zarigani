class CreateUserNicknames < Sequel::Migration
  def up
    create_table :user_nicknames do
      primary_key :id
      String :nickname
      foreign_key :user_id, :table => :users
    end
  end

  def down
    drop_table :user_nicknames
  end
end

