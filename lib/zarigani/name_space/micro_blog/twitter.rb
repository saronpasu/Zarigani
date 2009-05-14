module Zarigani::NameSpace
  module Twitter
    include Zarigani::NameSpace::MicroBlog
    class Entry::Body
      include Twitter
    end
    class DirectMessage::Body
      include Twitter
    end
  end
end

