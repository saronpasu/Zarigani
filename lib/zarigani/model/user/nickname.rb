class Zarigani
  module Model
    class User
      class Nickname < Sequel::Model
        set_schema do
          primary_key :id
          String :nickname

          foreign_key :user_id, :table => :users
        end
        set_dataset :user_nicknames

        many_to_one :user,
          :class => 'Zarigani::Model::User',
          :uniq => true
      end
    end
  end
end

