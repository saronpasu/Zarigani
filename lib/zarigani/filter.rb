class Zarigani
=begin :rdoc:
主に、発話時に使うフィルタ群。
ここでいうフィルタの概念は、「出力を整形するために使うもの」としている。
=end
  module Filter
    autoload :NameReplace, 'zarigani/filter/name_replace.rb'
    autoload :RejectURI, 'zarigani/filter/reject_uri.rb'
  end
end

