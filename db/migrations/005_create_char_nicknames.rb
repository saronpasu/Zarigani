class CreateCharNicknames < Sequel::Migration
  def up
    create_table :char_nicknames do
      primary_key :id
      text :nickname
      foreign_key :charactor_id, :table => :charactors
    end
  end

  def down
    drop_table :char_nicknames
  end
end

