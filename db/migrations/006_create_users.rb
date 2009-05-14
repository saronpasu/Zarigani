class CreateUsers < Sequel::Migration
  def up
    create_table :users do
      primary_key :id
      String :unique_name
      String :name
      String :screen_name
      foreign_key :charactor_id, :table => :charactors
      foreign_key :place_id, :table => :places
    end
  end

  def down
    drop_table :users
  end
end

