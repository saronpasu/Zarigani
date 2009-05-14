class Zarigani
  module Model
    class User
      class FollowedUsers < Sequel::Model
        set_schema do
          foreign_key :user_id,
            :table => :users,
            :null => false
          foreign_key :followed_user_id,
            :talbe => :users,
            :null => false
          primary_key [:user_id, :followed_user_id]
        end

        many_to_one :user,
          :table => :users,
          :class => 'Zarigani::Model::User'

        many_to_one :followeds,
          :table => :users,
          :talbe => :followed_user_id,
          :class => 'Zarigani::Model::User'
      end
    end
  end
end

