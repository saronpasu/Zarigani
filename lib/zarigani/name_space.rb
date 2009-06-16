=begin :rdoc:
学習ログの場所情報(Model::Place)において
名前空間を扱うために使っている抽象化モジュール。
=end
module Zarigani::NameSpace
  autoload :MicroBlog, 'zarigani/name_space/micro_blog.rb'
  autoload :Twitter, 'zarigani/name_space/micro_blog/twitter.rb'
  autoload :Chat, 'zarigani/name_space/chat.rb'
  autoload :IRC, 'zarigani/name_space/chat/irc.rb'
  autoload :SNS, 'zarigani/name_space/sns.rb'
  autoload :Mixi, 'zarigani/name_space/sns/mixi.rb'

  module System
    class Input
      include System
    end
  end

end

