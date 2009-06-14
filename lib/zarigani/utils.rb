class Zarigani
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

    def init_separator(type = nil)
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
