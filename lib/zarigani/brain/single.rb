class Zarigani::Brain::Single
  Behaviors = [
    :any
  ]
  Priority = 10

  include Zarigani::Brain

  attr_accessor :user_data, :config, :sep_ja, :sep

  def initialize(config, user_data, sep_ja, sep)
    @user_data = user_data
    @config = config
    @sep_ja = sep_ja
    @sep = sep
  end

  def select_source(lang)
    logs = Zarigani::Model::SourceLog.filter(:language => lang, :charactor_id => @config[:charactor_id]).order(:learned_at).limit(200).all
  end

  def talk(input)
    lang = 'japanese'
    source = select_source(lang)
    dict = init_dict(source)
    sep = lang == 'japanese' ? @sep_ja : @sep
    keyword = choice_keyword(source, sep)
    result = markov_chain(keyword, dict)
    return result
  end
end

