class Zarigani
  module Model
    class Charactor
      class Nickname < Sequel::Model
        set_schema do
          primary_key :id
          text :nickname
          foreign_key :charactor_id, :table => :charactors
        end
        set_dataset :char_nicknames

        many_to_one :charactor,
          :class => 'Zarigani::Model::Charactor',
          :uniq => true
      end
    end
  end
end

