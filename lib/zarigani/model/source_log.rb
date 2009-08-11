class Zarigani
  module Model
    class SourceLog < Sequel::Model
      plugin :Schema
      set_schema do
        primary_key :id
        text :original_text
        DateTime :learned_at
        String :language
        foreign_key :charactor_id, :table => :charactors
        foreign_key :place_id, :table => :places
        foreign_key :user_id, :table => :users
      end

      many_to_one :charactor,
        :class => 'Zarigani::Model::Charactor'

      one_to_many :words,
        :table => :source_words,
        :select => :word,
        :class => 'Zarigani::Model::SourceLog::Word'

      many_to_one :place,
        :class => 'Zarigani::Model::Place'

      many_to_one :user,
        :class => 'Zarigani::Model::User'
    end
  end
end

