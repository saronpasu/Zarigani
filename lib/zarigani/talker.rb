class Zarigani
  class Talker
    require 'zarigani/utils'
    include Utils
    require 'zarigani/brain'

    attr_accessor :db, :config, :user_data, :sep_ja, :sep

    def initialize(user_data = nil)
      @config = load_config
      @db = connect_db(@config[:db_path])
      @sep_ja = init_separator(:ja)
      @sep = init_separator
      @user_data = user_data
    end

    def select_brain(input)
      brain = nil
      case
        when (input.user and input.text)
          # response
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior === :response) or
              (behavior === :any)
            }
          }
          brain = brains[rand(brains.size)]
        when input.user
          # talk to user
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :talk_to) or
              (behavior == :any)
            }
          }
          brain = brains[rand(brains.size)]
        when input.text
          # talk about text
          brains = Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :talk_about) or
              (behavior == :any)
            }
          }
          brain = brains[rand(brains.size)]
        else
          # single talk
          brains = Zarigani::Brain.select{|brain|
            brain::Behaviors.find{|behavior|
              (behavior == :any)
            }
          }
          brain = brains[rand(brains.size)]
      end
      return brain
    end

    def talk(input)
      brain_class = select_brain(input)
      brain = brain_class.new(@config, @user_data, @sep_ja, @sep)
      text = brain.talk(input)
      return text
    end
  end
end
