class CreateSourceWords < Sequel::Migration
  def up
    create_table :source_words do
      primary_key :id
      String :word
      String :language
      foreing_key :source_log_id, :table => :source_logs
    end
  end

  def down
    drop_table :source_words
  end
end

