class Zarigani
  module Filter
    module RejectURI
      def reject_uri(input)
        uri_pattern = /^htt(p|ps)\:\/\/([a-zA-Z0-9_-]|\.\?&)+/
        output = input.gsub(uri_pattern, '')
        return output
      end
    end
  end
end

