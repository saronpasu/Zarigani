module Zarigani::NameSpace
  module SNS
    module Entry
      include SNS
      class Title
        include Entry
      end
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
    module Community
      include SNS
      module Topic
        include Community
        class Title
          include Topic
        end
        class Body
          include Topic
        end
        module Comment
          include Topic
          class Body
            include Comment
          end
        end
      end
    end
  end
end

