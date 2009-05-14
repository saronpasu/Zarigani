module Zarigani::NameSpace
  module IRC
    include Zarigani::NameSpace::Chat
    class Krass
      include IRC
    end
    def self.new
      Krass.new
    end
    class Message < Message
      include IRC
    end
    class PrivMessage < Message
    end
    class NoticeMessage < Message
    end
    module Channel
      include IRC
      include MultiUserChat
      class PrivMessage < PrivMessage
        include Channel
      end
      class NoticeMessage < NoticeMessage
        include Channel
      end
    end
    module Talk
      include IRC
      include SingleUserChat
      class PrivMessage < PrivMessage
        include Talk
      end
      class NoticeMessage < NoticeMessage
        include Talk
      end
    end
  end
end

