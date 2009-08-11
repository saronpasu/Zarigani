class Zarigani
  module Model
    class User
      class FollowingUsers < Sequel::Model
        plugin :Schema
        set_schema do
          foreign_key :user_id,
            :table => :users,
            :null => false
          foreign_key :following_user_id,
            :table => :users,
            :null => false
          primary_key [:user_id, :following_user_id]
        end

        many_to_one :user,
          :table => :users,
          :class => 'Zarigani::Model::User'

        many_to_one :friends,
          :table => :users,
          :key => :following_user_id,
          :class => 'Zarigani::Model::User'
      end
    end
  end
end

