class CreatePlaces < Sequel::Migration
  def up
    create_table :places do
      primary_key :id
      String :name
      String :format
    end
  end

  def down
    drop_table :places
  end
end

