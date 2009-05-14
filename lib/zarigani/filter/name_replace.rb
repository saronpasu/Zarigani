#!ruby -Ku
#-*- encoding: UTF-8 -*-
class Zarigani
  module Filter
    module NameReplace
      # 無脳の名前や相手にとって未知の人名が出た場合、
      # それを相手(＋共通の友人 or 相手の友人)の名前で
      # 置き換える
      # user.all_names #=> すべての呼び名
      # user.friendly_name #=> 親しげな呼び名
      # nickname > screen_name > name > unique_name
      # target (many_name)
      # replace (single_name)
      def replace_to_friend(input, user, self_data)
        target = self_data.all_names
        replace = user.friends.map{|fr|fr.friendly_name}.unshift(user.friendly_name)
        output = name_replace(input, target, replace)
        return output
      end

      def replace_to_user(input, user, self_data)
        target = self_data.all_names
        replace = [user.friendly_name]
        output = name_replace(input, target, replace)
        return output
      end

      # target and replace are array in names
      def name_replace(input, target, replace)
        pattern = '('+target.join('|')+')'
        reg = Regexp.compile(pattern)
        matched = input.scan(reg)
        return input if matched.empty?
        matched.uniq.flatten!
        replace = (replace - matched)[0..matched.size-1]
        h = Hash.new(replace.first)
        replace.each do |i|
          h[matched.shift] = i
        end
        output = input.gsub(reg){|m|h[m]}
        return output
      end
    end
  end
end

