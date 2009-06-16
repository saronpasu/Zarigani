#!ruby -Ku
# -*- encoding: utf-8 -*-

=begin rdoc
=end
class Zarigani
  MAJOR = '0'
  MINOR = '0'
  TINY = '1'
  VERSION = [MAJOR, MINOR, TINY].join('.')

  require 'zarigani/utils'
  include Utils
  autoload :TextParser, 'zarigani/text_parser.rb'
  autoload :Markov, 'zarigani/markov.rb'
  autoload :Talker, 'zarigani/talker.rb'
  autoload :Learner, 'zarigani/learner.rb'

  attr_accessor :config, :db, :user_data

=begin :rdoc:
コアクラス。通常使わないことになるかも。
=end
  def initialize
    @config = load_config
    @db = connect_db(@config[:db_path])
  end

=begin :rdoc:
コアからの発話。
=end
  def talk(input)
    if input.text
      learner = Learner.new
      learner.traning(input.text)
      learner.learn(input)
    end
    talker = Talker.new(@user_data)
    res = talker.talk(input)
    return res
  end

=begin :rdoc:
コアからの学習。使わないかも。
=end
  def learn(input)
    learner = Learner.new
    learner.traning(input.text)
    learner.learn(input)
  end
end

