module Zarigani::Brain
  require 'zarigani/markov'
  require 'zarigani/text_parser'
  include Markov, TextParser

  def self.select(&block)
    self.constants.map{|const|self.const_get(const)}.select{|const|block.call const}.sort{|i,j|j::Priority<=>i::Priority}
  end

  def init_dict(source_logs)
    logs = source_logs.map{|log|log.words.map{|word|word.word}}
    if RUBY_VERSION.match(/1\.9/) then
      logs.map!{|log|log.map!{|word|word.force_encoding('UTF-8')}}
    end
    dict = create_dict(logs)
    return dict
  end

=begin
  def init_separator(lang)
    cond = {:language => lang}
    separators = Zarigani::Model::Separator.filter(cond).order(:score).order(:score.desc).limit(20).map{|sep|
      if RUBY_VERSION.match(/1\.9/) then
        sep[:word].force_encoding('UTF-8')
      else
        sep[:word]
      end
    }
    return separators
  end
=end

  def get_keyword(text, sep)
    keywords = parse_text(text, sep)
    keywords.reject!{|word|sep.include?(word)}
    keyword = keywords[rand(keywords.size)]
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

