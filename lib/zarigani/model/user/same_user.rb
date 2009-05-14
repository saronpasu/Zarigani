class Zarigani
  module Model
    class User
      class SameUser < Sequel::Model
        set_schema do
          foreign_key :user_id,
            :table => :users,
            :null => false
          foreign_key :same_user_id,
            :table => :users,
            :null => false
          primary_key [:user_id, :same_user_id]
        end
        set_dataset :user_same_users

        many_to_one :user,
          :class => 'Zarigani::Model::User'

        many_to_one :same_users,
          :table => :users,
          :key => :same_user_id,
          :class => 'Zarigani::Model::User'
      end
    end
  end
end

