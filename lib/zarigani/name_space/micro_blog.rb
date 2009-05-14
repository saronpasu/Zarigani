module Zarigani::NameSpace
  module MicroBlog
    module Entry
      include MicroBlog
      class Body
        include Entry
      end
      module Comment
        include Entry
        class Body
          include Comment
        end
      end
    end
    module DirectMessage
      include MicroBlog
      class Body
        include DirectMessage
      end
    end
  end
end

