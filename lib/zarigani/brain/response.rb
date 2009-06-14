class Zarigani::Brain::Response
  Behaviors = [
    :response
  ]
  Priority = 40

  include Zarigani::Brain
  require 'zarigani/filter'
  include Zarigani::Filter
  include NameReplace

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
    lang = 'japanese' if is_japanese?(input.text)
    input.lang = lang
    source = select_source(lang)
    dict = init_dict(source)
    sep = lang == 'japanese' ? @sep_ja : @sep
    # FIXME: キーワード抽出を実装しましょう
    keyword = get_keyword(input, source)
    result = markov_chain(keyword, dict)
    if input.user.friends.empty?
      result = replace_to_user(result, input.user, @user_data)
    else
      result = replace_to_friend(result, input.user, @user_data)
    end
    return result
  end
end

