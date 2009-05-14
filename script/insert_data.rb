#!ruby -Ilib
# -*- encoding: UTF-8 -*-

require 'sequel'
DB = Sequel.sqlite('db/default.db')

require 'zarigani/model'

include Zarigani::Model

charactor = Charactor.new do |c|
  c.screen_name = 'ザリガニ'
  c.unique_name = 'zarigani'
  c.save
end

user = User.new do |u|
  u.name = 'zarigani'
  u.unique_name = 'zarigani'
  u.screen_name = 'ザリガニ'
  u.save
end

place = Place.new do |pl|
  pl.name = "system input"
  pl.name_space = "System::Input"
  pl.save
end

nickname = User::Nickname.new do |nick|
  nick.nickname = "ザリちょん"
  nick.save
end

user.place = place
user.add_nickname(nickname)
user.save
charactor.add_user_data(user)
charactor.save



