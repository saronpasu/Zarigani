class CreateSeparators < Sequel::Migration
  def up
    create_table :separators do
      primary_key :id
      String :word
      Fixnum :score, :default => 0
      String :language
    end
  end

  def down
    drop_table :separators
  end
end

