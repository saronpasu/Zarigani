class Zarigani
  module Plugin
    require 'zarigani/talker'
    class SixamoTalker < Zarigani::Talker
      def talk(input)
        str = input.text
        logs = @db[:source_logs].order(:learned_at.desc).select(:original_text).all
        return nil if logs.size.zero?
        logs.map! do |log|
          if RUBY_VERSION.match(/^1\.9/) then
            log[:original_text].force_encoding('UTF-8')
          else
            log[:original_text]
          end
        end
        response = nil
        require 'tmpdir'
        Dir.mktmpdir('sixamo') do |dirname|
          open("#{dirname}/sixamo.txt", 'w'){|f|f.print(logs.join('\n'))}
          require 'plugin/sixamo/lib/sixamo'
          sixamo = Sixamo.new(dirname)
          response = sixamo.talk(str)
        end
        return response
      end
    end
  end
end

