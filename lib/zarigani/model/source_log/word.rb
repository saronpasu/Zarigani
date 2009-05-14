class Zarigani
  module Model
    class SourceLog
      class Word < Sequel::Model
        set_schema do
          primary_key :id
          String :word
          String :language
          foreign_key :source_log_id,
            :table => :source_logs
        end
        set_dataset :source_words

        many_to_one :source_log,
          :class => 'Zarigani::Models::SourceLog'
      end
    end 
  end
end

