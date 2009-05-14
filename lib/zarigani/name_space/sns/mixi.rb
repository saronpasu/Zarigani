module Zarigani::NameSpace
  module Mixi
    include Zarigani::NameSpace::SNS
    module Diary
      include Mixi
      include Entry
      class Title
        include Diary
      end
      class Body
        include Diary
      end
      class Comment::Body
        include Diary
      end
    end
    class Community::Topic::Title
      include Mixi
    end
    class Community::Topic::Body
      include Mixi
    end
    class Community::Topic::Comment::Body
      include Mixi
    end
  end
end

