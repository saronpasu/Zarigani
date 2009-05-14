#!ruby -Ku
#-*- encoding: UTF-8 -*-
class Zarigani
  module Client
    require 'net/irc'
    # Net-IRC's BUG: Net::IRC::Client#post
    require 'zarigani/client/client_patch.rb'
    #require 'zarigani/client/irc_monkeypatch.rb'
    require 'ostruct'
    require 'kconv'
    class IRC_Client < Net::IRC::Client
      attr_accessor :learn, :talk, :join_channels,
        :short_host, :user_data

      def initialize(*args)
        super
      end

      def on_rpl_welcome(m)
        # join
        @join_channels.each do |channel|
          post JOIN, channel
        end
      end

      def is_command?(m)
        # add_nickname
        bot_name_pattern = '(?:'+@user_data.all_names.uniq.flatten.join('|')+')'
        nick_name_pattern = '(?:「'+m.prefix.nick+'」)'
        name_pattern = '(?:「)(.+)(?=」)'
        pattern = '^'+bot_name_pattern
        pattern.force_encoding('UTF-8') if RUBY_VERSION.match(/1\.9/)
        pattern += '.*'+nick_name_pattern
        pattern += 'のあだ名は'+name_pattern+'.*(?:だ|です).*$'
        reg = Regexp.compile(pattern)

        message = m[1]
        message = message.kconv(Kconv::UTF8, Kconv::JIS) if @short_host == 'wide'
        message.match(reg)
        new_nickname = $1
        if new_nickname then
          # find place
          user_place = Zarigani::Model::Place.find_or_create(
            :name => @short_host,
            :name_space => 'IRC'
          )
          # find user
          user = Zarigani::Model::User.find(
            :name => m.prefix.nick,
            :place_id => user_place.id
          )
          user = Zarigani::Model::User.find(
            :unique_name => m.prefix.user+m.prefix.host,
            :place_id => user_place.id
          ) unless user
          user = Zarigani::Model::User.find_or_create(
            :name => m.prefix.nick,
            :unique_name => m.prefix.user+m.prefix.host,
            :place_id => user_place.id
          ) unless user
          result = nil
@log.debug(__LINE__)
          unless user.nicknames.find{|i|i.nickname == new_nickname}
            user.add_nickname Zarigani::Model::User::Nickname.create(:nickname=>new_nickname)
            result = [m.prefix.nick+'のあだ名として、「'+new_nickname+'」を覚えました。']
            nicknames = user.nicknames.map{|i|
              if RUBY_VERSION.match(/1\.9/) then
                i.nickname.force_encoding('UTF-8')
              else
                i.nickname
              end
            }.uniq.flatten
            result << m.prefix.nick+'のあだ名は、「'+nicknames.join('」、「')+'」です。'
          else
            result = [m.prefix.nick+'のあだ名として、「'+new_nickname+'」は、もう覚えてあります。']
          end
          result.each do |res|
            res = res.kconv(Kconv::JIS, Kconv::UTF8) if @short_host == 'wide'
            post NOTICE, m[0], res
          end if result
          return true
        else
          return nil
        end
      end

      def on_privmsg(m)
        return nil if m.prefix.user.nil?
        channel = m[0]
        message = m[1]
        message.force_encoding('UTF-8') if @short_host != 'wide' && RUBY_VERSION.match(/1\.9/)
        # command_case
        return nil if is_command?(m)

        # learn_only
        nick = m.prefix.nick
        user_place = Zarigani::Model::Place.find_or_create(
          :name => @short_host, :name_space => 'IRC'
        )
        user = Zarigani::Model::User.find(
          :name => m.prefix.nick,
          :place_id => user_place.id
        )
        user = Zarigani::Model::User.find(
          :unique_name => m.prefix.user+m.prefix.host,
          :place_id => user_place.id
        ) unless user
        user = Zarigani::Model::User.find_or_create(
          :name => m.prefix.nick,
          :unique_name => m.prefix.user+m.prefix.host,
          :place_id => user_place.id
        ) unless user
        place = Zarigani::Model::Place.find_or_create(
          :name => @short_host+' '+channel,
          :name_space => 'IRC::Channel::PrivMessage'
        )
        input = OpenStruct.new
        input.user = user
        input.place = place
        input.text = message
        input.text = message.kconv(Kconv::UTF8, Kconv::JIS) if @short_host == 'wide'
        @learn.call(input)

        # talk
        key = rand(6)
@log.debug('random_key: '+key.to_s)
        if key < 4 then
          send_message = @talk.call(input)
          send_message = send_message.kconv(Kconv::JIS, Kconv::UTF8) if @short_host == 'wide'
@log.debug(send_message.encoding) if RUBY_VERSION.match(/1\.9/)
          post NOTICE, channel, send_message
        end
      end

      def on_notice(m)
        return nil if m.prefix.user.nil?

        # learn_only
        channel = m[0]
        message = m[1]
        user_place = Zarigani::Model::Place.find_or_create(
          :name => @short_host,
          :name_space => 'IRC'
        )
        user = Zarigani::Model::User.find(
          :name => m.prefix.nick,
          :place_id => user_place.id
        )
        user = Zarigani::Model::User.find(
          :unique_name => m.prefix.user+m.prefix.host,
          :place_id => user_place.id
        ) unless user
        user = Zarigani::Model::User.find_or_create(
          :name => m.prefix.nick,
          :unique_name => m.prefix.user+m.prefix.host,
          :place_id => user_place.id
        ) unless user
        place = Zarigani::Model::Place.find_or_create(
          :name => @short_host+' '+channel,
          :name_space => 'IRC::Channel::NoticeMessage'
        )

        input = OpenStruct.new
        input.user = user
        input.place = place
        input.text = message
        input.text = message.kconv(Kconv::UTF8, Kconv::JIS) if @short_host == 'wide'
        input.text = message.force_encoding('UTF-8') if @short_host != 'wide' && RUBY_VERSION.match(/1\.9/)
        @learn.call(input)
      end
    end
  end
end

