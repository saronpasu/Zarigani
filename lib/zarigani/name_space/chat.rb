module Zarigani::NameSpace
  module Chat
    class Message
    end
    module SingleUserChat
      include Chat
      class Message < Message
        include SingleUserChat
      end
    end
    module MultiUserChat
      include Chat
      class Message < Message
        include MultiUserChat
      end
    end
  end
end

