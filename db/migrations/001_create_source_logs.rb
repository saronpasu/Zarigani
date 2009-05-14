class CreateSourceLogs < Sequel::Migration
  def up
    create_table :source_logs do
      primary_key :id
      text :original_text
      DateTime :learned_at
      String :language
      foreign_key :charactor_id, :table => :charactors
      foreign_key :place_id, :table => :places
      foreign_key :user_id, :table => :users
    end
  end

  def down
    drop_table :source_logs
  end
end

