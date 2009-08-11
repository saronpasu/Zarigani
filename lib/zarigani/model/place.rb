require 'zarigani/name_space'

class Zarigani
  module Model
    class Place < Sequel::Model
      plugin :Schema
      set_schema do
        primary_key :id
        String :name, :unique => true
        String :name_space
      end

      # ex) pattern = 'IRC::PrevMessage'
      def self.select_name_space(pattern, cond)
        include Zarigani::NameSpace
        return nil if self.filter(cond).count.zero?
        self.filter(cond).all.select{|place|
          eval(place.name_space+'.new').kind_of? eval(pattern)
        }
      end
    end
  end
end

