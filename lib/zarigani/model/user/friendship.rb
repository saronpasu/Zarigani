class Zarigani
  module Model
    class User
      class FriendShip < Sequel::Model
        plugin :Schema
        set_schema do
          foreign_key :user_id,
            :table => :users
          foreign_key :friend_id,
            :table => :users
          primary_key [:user_id, :friend_id]
        end
        set_dataset :user_frienships

        many_to_one :user,
          :class => 'Zarigani::Model::User'

        many_to_one :friends,
          :table => :users,
          :key => :friend_id,
          :class => 'Zarigani::Model::User'
      end
    end
  end
end

