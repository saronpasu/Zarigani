class Zarigani
=begin :rdoc:
ユーティリティたち。
他のモジュールへ移すべきものがあれば、移管するかも。
=end
  module Utils
    def encoding_supported?
      String.allocate.respond_to? :encoidng
    end

    def load_config
      require 'yaml'
      config = open('config.yml', 'r'){|f|YAML::load(f.read)}
      return config
    end

    def connect_db(db_path)
      require 'sequel'
      db = Sequel.sqlite(db_path)
      require 'zarigani/model'
      return db
    end

=begin :rdoc:
DBから区切り句(separator)を取得する
引数(type)の指定により、すべて取得(:all)か
日本語のみ取得(:ja)か、日本語以外を取得(nil)になる
デフォルトは日本語以外(nil)
=end
    def init_separator(type = nil)
	  # return nilではなく、例外処理に差し替える
      return nil if Model::Separator.count.zero?
      dataset = Model::Separator.order(:score.desc)
      case type
        when :all
          sep = dataset.all
          sep = sep.each{|s|s.word.force_encoding('UTF-8')} if encoding_suppported?
        when :ja
          sep = dataset.filter(:language=>'japanese').limit(40).map{|s|
            if encoding_supported? then
              s.word.force_encoding('UTF-8')
            else
              s.word
            end
          }.uniq
        else
          sep = dataset.filter(:language=>nil).limit(40).map{|s|
            if encoding_supported? then
              s.word.force_encoding('UTF-8')
            else
              s.word
            end
          }.uniq
      end
      return sep
    end
  end
end
