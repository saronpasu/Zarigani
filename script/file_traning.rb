#!ruby -Ilib -Ku
#-*- encoding: UTF-8 -*-

require 'zarigani/learner'

learner = Zarigani::Learner.new

if RUBY_VERSION.match(/1\.9/) then
  opt = 'r:utf-8'
else
  opt = 'r'
end

file = open('learn_data/sixamo.txt', opt)

learner.io_traning(file)



