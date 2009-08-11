class Zarigani
  module Model
    class User < Sequel::Model
      plugin :Schema
      set_schema do
        primary_key :id
        String :unique_name
        String :name
        String :screen_name
        foreign_key :charactor_id, :table => :charactors
        foreign_key :place_id, :table => :places
      end

      many_to_one :charactor,
        :class => 'Zarigani::Model::Charactor'

      one_to_many :nicknames,
        :table => :user_nicknames,
        :select => :nickname,
        :class => 'Zarigani::Model::User::Nickname'

      many_to_one :place,
        :class => 'Zarigani::Model::Place'

      many_to_many :friends,
        :table => :users,
        :left_key => :user_id,
        :right_key => :friend_id,
        :join_table => :user_friendships,
        :class => 'Zarigani::Model::User'

      many_to_many :followings,
        :table => :users,
        :left_key => :user_id,
        :right_key => :following_user_id,
        :join_table => :following_users,
        :class => 'Zarigani::Model::User'

      many_to_many :followeds,
        :table => :users,
        :left_key => :user_id,
        :right_key => :followed_user_id,
        :join_table => :followed_users,
        :class => 'Zarigani::Model::User'

      def all_names
        names = self.values.values_at(:screen_name, :name)
        nicknames = self.nicknames
        unless nicknames.empty?
          names += nicknames.map{|i|i[:nickname]}
        end
        result = names.compact.uniq
        result.each{|i|i.force_encoding('UTF-8')} if RUBY_VERSION.match(/1\.9/)
        return result
      end

      def friendly_name
        result = nil
        case
          when !(nicknames = self.nicknames).empty?
            result = nicknames[rand(nicknames.size)][:nickname]
          when screen_name = self.screen_name
            result = screen_name
          when name = self.name
            result = name
          when unique_name = self.unique_name
            result = unique_name
        end
        result.force_encoding('UTF-8') if RUBY_VERSION.match(/1\.9/) && result
        return result
      end
    end
  end
end

