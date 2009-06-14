#!ruby -Ku
# -*- encoding: UTF-8 -*-

module TextParser
  def encoding_supported?
    String.allocate.respond_to? :encoding
  end

  def is_japanese?(text)
    if encoding_supported? then
      reg = Regexp.compile("[^[:ascii:]]")
    else
      reg = Regexp.compile("[^[:alpha:][:digit:][:blank:][:punct:]]")
    end
    return text.match(reg) ? true : false
  end

  def escape_regexp_string(text)
    pattern = /[\.\|\(\)\[\]\\\^\$\?\*]/
    text.gsub(pattern){|m|"\\"+m}
  end 

  def find_separator(text, separators = nil)
    if is_japanese?(text)
      default_pattern = /./
      lang = 'japanese'
    else
      default_pattern = / /
    end
    unless separators then
      list = text.scan(default_pattern).uniq
      separators = list.map{|i|{:word=>i,:score=>0,:language=>lang}}
    end
    separators.each do |separator|
      word = escape_regexp_string(separator[:word])
      pattern = Regexp.new(word)
      if (score = text.scan(pattern).size) > 1
        separator[:score] += score - 1
        before = text.scan(Regexp.new('.'+word))
        after = text.scan(Regexp.new(word+'.'))
        new_sep = []
        case
          when (
            before.size > 1 &&
            (before - separators.map{|i|i[:word]}).size.nonzero?
          )
            new_sep += before
          when (
            after.size > 1 &&
            (after - separators.map{|i|i[:word]}).size.nonzero?
          )
            new_sep += after
        end
        unless new_sep.empty?
          new_sep = new_sep.uniq.map{|i|{:word=>i,:score=>0,:language=>lang}}
          separators.push(new_sep).flatten!
        end
      end
    end
    separators.reject!{|i|i[:score].zero?}
    separators.sort!{|i,j|j[:score]<=>i[:score]}
    return nil if separators.size.zero?
    return separators
  end

  def merge_separators(sep_a, sep_b)
    sep_a.each{|a|
      b=sep_b.find{|v|v[:word].eql?(a[:word])}
      a[:score] += b[:score] if b
    }
    sep_b.reject!{|b|sep_a.map{|v|v[:word]}.include?(b[:word])}
    return (sep_a + sep_b).sort{|i,j|j[:score]<=>i[:score]}
  end


  def to_words(text, target_word)
    target_word = escape_regexp_string(target_word)
    pattern = Regexp.new("(^.+)(#{target_word})(.+$)")
    pattern = /(^.+ )(.+$)/ unless is_japanese?(text)
    match_data = text.match(pattern)
    return nil unless match_data
    head, tail = match_data[1], match_data[2..-1]
    data = to_words(head, target_word) || head
    result = tail.unshift(data).flatten
    return result
  end

  def parse_text(target, words)
    if target.kind_of?(String) then
      target = [target]
      words = words.dup
    end
    if words.size.zero? then
      return target
    else
      word = words.shift
    end

    result = target.map do |i|
      to_words(i, word) || i
    end.flatten

    result = parse_text(result, words)
    return result
  end

  # 複数の文章から成る入力を、文章ごとに分割し
  # 配列として返す
  # メソッド名は変えるべき
  def split_text(text, target_word)
    target_word = escape_regexp_string(target_word)
    pattern = Regexp.new("(^.+#{target_word})(.+$)")
    match_data = text.match(pattern)
    return [text] unless match_data
    head, tail = match_data[1], match_data[2..-1]
    data = split_text(head, target_word)
    result = tail.unshift(data).flatten
    return result
  end
end


