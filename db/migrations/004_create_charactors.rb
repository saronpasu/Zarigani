class CreateCharactors < Sequel::Migration
  def up
    create_table :charactors do
      primary_key :id
      String :unique_name
      String :screen_name
    end
  end

  def down
    drop_table :charactors
  end
end

