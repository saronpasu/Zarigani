class Zarigani
  module Model
    class Charactor < Sequel::Model
      set_schema do
        primary_key :id
        String :unique_name
        String :screen_name
      end

      one_to_many :user_datas,
        :table => :users,
        :class => 'Zarigani::Model::User'

      one_to_many :nicknames,
        :table => :char_nicknames,
        :select => :nickname,
        :class => 'Zarigani::Model::Charactor::Nickname'
    end
  end
end

