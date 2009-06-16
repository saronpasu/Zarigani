class Zarigani
  class Learner
    require 'zarigani/utils'
    include Utils
    require 'zarigani/text_parser'
    include TextParser

    attr_accessor :config, :db, :user_data,
      :sep_all, :sep_ja, :sep

=begin :rdoc:
学習器(lerner)インスタンスを生成する。
=end
    def initialize
      @config = load_config
      @db = connect_db(@config[:db_path])
      @sep_all = init_separator(:all)
      @sep_ja = init_separator(:ja)
      @sep = init_separator
      return true
    end

=begin :rdoc:
未使用。削除するかも
=end
    def set_screen_name(screen_name, user_info)
      target = Model::User.filter(user_info).all.first
      target.screen_name = screen_name
      target.save
      return true
    end

=begin :rdoc:
未使用。削除するかも
=end
    def set_nickname(nickname, user_info)
      target = Model::User.filter(user_info).all.first
      unless target.nicknames.size.zero?
        return false if target.nicknames.find{|n|n.nickname.eql?(nickname)}
      end
      target.add_nickname(Model::User::Nickname.new(:nickname => nickname))
      return true
    end

=begin :rdoc:
文章解析器のトレーニングを行う。
=end
    def traning(str)
      sep ||= @sep_all
      sep = find_separator(str, sep)
      return nil if sep.nil?
      new_sep = sep.select{|s|s[:id].nil?}
      @db[:separators].insert_multiple new_sep
      (sep - new_sep).each do |s|
        s.save
      end
      return true
    end

=begin :rdoc:
入力情報(input)を観察(listen)し、学習ログ(source_log)として整形して返す
=end
    def listen(input)
      input.lang ||= 'japanese' if input.text and is_japanese?(input.text)
      src = Model::SourceLog.new do |s|
        s.charactor_id = @config[:charactor_id]
        s.original_text ||= input.text
        s.learned_at = DateTime.now
        s.language ||= input.lang
        s.place ||= input.place
        s.user ||= input.user
      end
      return src
    end

=begin :rdoc:
入力情報(input)を学習する。
=end
    # FIXME: 未テスト
    def learn(input)
      return nil if Model::Separator.count.zero?
      return nil unless input.text
      src = listen(input)
      separators = input.lang.eql?('japanese') ? @sep_ja : @sep
=begin
      lang = 'japanese' if is_japanese?(input.text)
      sep ||= lang == 'japanese' ? @sep_ja : @sep
      src = Model::SourceLog.new
      src.charactor_id = @config[:charactor_id]
      src.original_text = input.text
      src.learned_at = DateTime.now
      src.language ||= lang
      src.place ||= input.place
      src.user ||= input.user
=end
      src.save
      words ||= parse_text(input.text, sep) if input.text
      words.each do |w|
        src.add_word Model::SourceLog::Word.new(
          :word => w, :language => src.language
        )
      end
    end

=begin :rdoc:
IOオブジェクトを与えて、一気に文章解析器をトレーニングする。
=end
    def io_traning(io)
      io.readlines.each do |line|
        traning(line)
        @sep_all = init_separator(:all)
      end
    end

=begin :rdoc:
IOオブジェクトを与えて、一気に学習させる。
場所情報(Model::Place)や、ユーザ情報(Model::User)を与えることで
特定の場所、ユーザの発言として学習することも可能。
=end
    def io_learn(io, place = nil, user = nil)
      Struct.new("Dummy", :text, :place, :user)
      input = Struct::Dummy.new
      input.place ||= place
      input.user ||= user
      io.readlines.each do |line|
        line.chomp!
        traning(line)
        @sep_all = init_separator(:all)
      end
      @sep_ja = init_separator(:ja)
      @sep = init_separator
      io.rewind
      io.readlines.each do |line|
        line.chomp!
        input.text = line
        learn(input)
      end
      return true
    end
  end
end

