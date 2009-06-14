module Zarigani::Brain
  require 'zarigani/markov'
  require 'zarigani/text_parser'
  include Markov, TextParser

  def encoding_supported?
    String.allocate.respond_to? :encoding
  end

  def self.select(&block)
    self.constants.map{|const|self.const_get(const)}.select{|const|block.call const}.sort{|i,j|j::Priority<=>i::Priority}
  end

  def init_dict(source_logs)
    logs = source_logs.map{|log|log.words.map{|word|word.word}}
    if encoding_supported? then
      logs.map!{|log|log.map!{|word|word.force_encoding('UTF-8')}}
    end
    dict = create_dict(logs)
    return dict
  end

=begin
  def init_separator(lang)
    cond = {:language => lang}
    separators = Zarigani::Model::Separator.filter(cond).order(:score).order(:score.desc).limit(20).map{|sep|
      if encoding_supported? then
        sep[:word].force_encoding('UTF-8')
      else
        sep[:word]
      end
    }
    return separators
  end
=end
  def log_find(words, source)
    group = source.reject{|src|src.words&words.empty?}
    return nil if group.empty?
    populer_word = words.sort{|i,j|
      group.select{|src|src.words.include?(j)}.size<=>group.select{|src|src.words.include?(i)}.size
    }.first
    return populer_word
  end

  def get_keyword(input, source)
    separator = input.lang.eql?('japanese') ? @sep_ja : @sep
    keywords = parse_text(input.text, separator)
    keywords.reject!{|word|separator.include?(word)}
    keyword = log_find(keywords, source)
    return keyword
  end

  def choice_keyword(source_logs, sep)
    words = source_logs[rand(source_logs.size)].words
    words.reject!{|word|sep.include? word}
    keyword = words[rand(words.size)].word
    return keyword
  end
end

Dir['**/brain/**/*.rb'].each{|f|load f}

