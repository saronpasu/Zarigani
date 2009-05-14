#!ruby -Ku -Ilib -rubygems
# -*- encoding: UTF-8 -*-

require 'sequel'
DB = Sequel.sqlite('db/default.db')

require 'zarigani/model'

charactor = Zarigani::Model::Charactor.find(:id=>1)
irc_user = charactor.user_datas.find{|user|
  user.place.name == 'wide' if user.place
}

require 'zarigani/talker'

talker = Zarigani::Talker.new(irc_user)

require 'zarigani/learner'

learner = Zarigani::Learner.new

require 'zarigani/client'

bot = Zarigani::Client::IRC_Client.new(
  'irc.fujisawa.wide.ad.jp', '6667', {
    :nick => 'zarigani',
    :user => 'zarigani',
    :real => 'zarigani'
  }
)
bot.talk = talker.method(:talk)
bot.learn = learner.method(:learn)
bot.join_channels = ['#zarigani']
bot.short_host = 'wide'
bot.user_data = irc_user

bot.start

