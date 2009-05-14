class Zarigani
  module Model
    class Separator < Sequel::Model
      set_schema do
        primary_key :id
        String :word
        Fixnum :score, :default => 0
        String :language
      end

      order :score
    end
  end
end

