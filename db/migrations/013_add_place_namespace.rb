class AddPlaceNameSpace < Sequel::Migration
  def up
    alter_table :places do
      add_column :name_space, String
    end
  end

  def down
    alter_table :places do
      drop_column :name_space
    end
  end
end

