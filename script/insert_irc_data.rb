#!ruby -Ilib
# -*- encoding: UTF-8 -*-

require 'sequel'
DB = Sequel.sqlite('db/default.db')

require 'zarigani/model'

include Zarigani::Model

user = User.new do |user|
  user.name = 'zarigani'
  user.unique_name = 'zarigani'
  user.screen_name = 'ザリガニ'
  user.save
end

place = Place.new do |place|
  place.name = 'freenode'
  place.name_space = 'IRC'
  place.save
end

nick = User::Nickname.new do |nick|
  nick.nickname = 'ザリー'
  nick.save
end

user.add_nickname nick
user.save

charactor = Charactor.find(:id=>1)
charactor.add_user_data(user)
charactor.user_datas.last.place = place
charactor.save

user = User.new do |user|
  user.name = 'zarigani'
  user.unique_name = 'zarigani'
  user.screen_name = 'ザリガニ'
  user.save
end

place = Place.new do |place|
  place.name = 'wide'
  place.name_space = 'IRC'
  place.save
end

nick = User::Nickname.new do |nick|
  nick.nickname = 'ザリー'
  nick.save
end

user.place = place
user.add_nickname nick
user.save
charactor.add_user_data user
charactor.save



