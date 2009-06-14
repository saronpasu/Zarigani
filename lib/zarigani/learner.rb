class Zarigani
  class Learner
    require 'zarigani/utils'
    include Utils
    require 'zarigani/text_parser'
    include TextParser

    attr_accessor :config, :db, :user_data,
      :sep_all, :sep_ja, :sep

    def initialize
      @config = load_config
      @db = connect_db(@config[:db_path])
      @sep_all = init_separator(:all)
      @sep_ja = init_separator(:ja)
      @sep = init_separator
      return true
    end

    def set_screen_name(screen_name, user_info)
      target = Model::User.filter(user_info).all.first
      target.screen_name = screen_name
      target.save
      return true
    end

    def set_nickname(nickname, user_info)
      target = Model::User.filter(user_info).all.first
      unless target.nicknames.size.zero?
        return false if target.nicknames.find{|n|n.nickname.eql?(nickname)}
      end
      target.add_nickname(Model::User::Nickname.new(:nickname => nickname))
      return true
    end

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

    # FIXME: 要リファクタリング 特にsrc.attr = value辺り Model.new do とか使って
    def learn(input)
      return nil if Model::Separator.count.zero?
      return nil unless input.text
      lang = 'japanese' if is_japanese?(input.text)
      sep ||= lang == 'japanese' ? @sep_ja : @sep
      src = Model::SourceLog.new
      src.charactor_id = @config[:charactor_id]
      src.original_text = input.text
      src.learned_at = DateTime.now
      src.language ||= lang
      src.place ||= input.place
      src.user ||= input.user
      src_id = src.save.id
      words = parse_text(input.text, sep)
      words.map do |w|
        src.add_word Model::SourceLog::Word.new(:word => w, :language => lang)
      end
      return true
    end

    def io_traning(io)
      io.readlines.each do |line|
        traning(line)
        @sep_all = init_separator(:all)
      end
    end

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

