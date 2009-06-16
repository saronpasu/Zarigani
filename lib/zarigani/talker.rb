class Zarigani
  class Talker
    require 'zarigani/utils'
    include Utils
    require 'zarigani/brain'

    attr_accessor :db, :config, :user_data, :sep_ja, :sep

=begin :rdoc:
発話器(Talker)インスタンスを生成。
キャラクターが複数のユーザデータを保持している場合は、
どのユーザとして発話するのかを指定することもできる。
無指定の場合は、ユーザデータを活用した発話を行わない。
=end
    def initialize(user_data = nil)
      @config = load_config
      @db = connect_db(@config[:db_path])
      @sep_ja = init_separator(:ja)
      @sep = init_separator
      @user_data = user_data
    end

=begin :rdoc:
入力(input)を観察(listen)して、どのようなメッセージ型(message_type)で返すべきか判断する
=end
    def listen input
      message_type = nil
      case
        when input.user and input.text
          message_type = :response
        when input.user
          message_type = :talk_to
        when input.text
          message_type = :talk_about
        else
          message_type = :any
      end
      # FIXME: ここでやるべきか？どっちにしろ必要
      # input.lang ||= is_japanese?(input.text) ? 'japanese' : 'english'
      return message_type
    end

=begin :rdoc:
入力情報(input)を観察(listen)し、発話(talk)に使うべき発話脳(brains)を選ぶ
=end
    # FIXME: 未テスト
    def select_brain(input)
      brains = nil
      message_types = [:any]
      message_types << listen(input)
      message_types.uniq!
      brains = Brain.select do |brain|
        brain::Behaviors & message_types
      end
=begin
      case
        when (input.user and input.text)
          # response
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior === :response) or
              (behavior === :any)
            }
          }
          #brain = brains[rand(brains.size)]
        when input.user
          # talk to user
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :talk_to) or
              (behavior == :any)
            }
          }
          #brain = brains[rand(brains.size)]
        when input.text
          # talk about text
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :talk_about) or
              (behavior == :any)
            }
          }
          #brain = brains[rand(brains.size)]
        else
          # single talk
          brains = Zarigani::Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :any)
            }
          }
          #brain = brains[rand(brains.size)]
      end
=end
      return brains
    end

=begin :rdoc:
発話脳(brains)で優先度順に発話を試みる
将来的にはししゃものように、たくさん試みてふるいをかけるようにしたい
=end
    # FIXME: 未実装
    def try_talk(brains, input)
    end

=begin :rdoc:
入力情報(input)を元に、どの発話脳(brain)を使うか判断し
発話脳を使って発話する。
=end
    # FIXME: プライオリティ順に発話を試行するようにする, tly_talk(brains, input) #=> resultを作る
    def talk(input)
      brains = select_brain(input)
      brain = brains.first.new(@config, @user_data, @sep_ja, @sep)
      text = brain.talk(input)
      return text
    end
  end
end
