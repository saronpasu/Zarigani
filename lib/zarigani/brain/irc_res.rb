class Zarigani::Brain::IRC_Response
  Behaviors = [
    :response
  ]
  Priority = 50

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

=begin :nodoc
なにやってるのかややこしいのでコメント。
input.place.nameに一致する場所をとってくる
その中から、名前空間がチャンネルメッセージに
一致するものでさらに絞り込む。
それらのIDを一度配列に入れて、それを文字列に直す。
{:place_id=>1}|{:place_id=>2}...みたいな
最後にそれをeval()でSequel::SQL::BooleanExpressionにする
そいつをSourceLog.filter(cond)に入れることで最終的に
チャンネル名と名前空間がマッチする場所のログを得る
=end
  def select_place(place_name)
    name_space = 'IRC::Message'
    # name_space = 'IRC::PrivMessage' #=> only PrivMessage
    places = Zarigani::Model::Place.select_name_space(name_space, {:name => place_name})
    return nil if places.nil? or places.empty?
    cond = '{:place_id => '
    cond += places.map{|i|i.id}.join('}|{:place_id => ')+'}'
    cond = eval(cond)
    return cond
  end

  def select_source(lang, place_cond)
    logs = Zarigani::Model::SourceLog.filter(:language => lang, :charactor_id => @config[:charactor_id]).filter(place_cond).order(:learned_at.desc).limit(200).all
  end

  def talk(input)
    lang = 'japanese' if is_japanese?(input.text)
    input.lang = lang
    place_cond = select_place(input.place.name)
$stdout.print([place_cond, "\n"])
    source = select_source(lang, place_cond) unless place_cond.nil?
$stdout.print([source.empty?, "\n"])
    return input.text unless source
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

