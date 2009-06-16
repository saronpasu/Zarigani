module Zarigani::Brain
  require 'zarigani/markov'
  require 'zarigani/text_parser'
  include Markov, TextParser

  # FIXME: 共通化する
  def encoding_supported?
    String.allocate.respond_to? :encoding
  end

  # :nodoc:
  def self.select(&block)
    self.constants.map{|const|self.const_get(const)}.select{|const|block.call const}.sort{|i,j|j::Priority<=>i::Priority}
  end

=begin :rdoc:
学習ログ(source_logs)を元に、マルコフ辞書(dict)を初期化して返す
=end
  def init_dict(source_logs)
    logs = source_logs.map{|log|log.words.map{|word|word.word}}
    if encoding_supported? then
      logs.map!{|log|log.map!{|word|word.force_encoding('UTF-8')}}
    end
    dict = create_dict(logs)
    return dict
  end

=begin :nodoc:
特徴語の抽出に使う内部関数。
=end
  # FIXME: 名前が悪い。処理内容を見直す。未テスト。
  def log_find(words, source)
    group = source.reject{|src|src.words&words.empty?}
    return nil if group.empty?
    populer_word = words.sort{|i,j|
      group.select{|src|src.words.include?(j)}.size<=>group.select{|src|src.words.include?(i)}.size
    }.first
    return populer_word
  end

=begin :rdoc:
入力情報(input)から、特徴的な単語(keyword)を探す。
=end
  def get_keyword(input, source)
    separator = input.lang.eql?('japanese') ? @sep_ja : @sep
    keywords = parse_text(input.text, separator)
    keywords.reject!{|word|separator.include?(word)}
    keyword = log_find(keywords, source)
    return keyword
  end

  # FIXME: 見直す必要あり。
  def choice_keyword(source_logs, sep)
    words = source_logs[rand(source_logs.size)].words
    words.reject!{|word|sep.include? word}
    keyword = words[rand(words.size)].word
    return keyword
  end
end

Dir['**/brain/**/*.rb'].each{|f|load f}

