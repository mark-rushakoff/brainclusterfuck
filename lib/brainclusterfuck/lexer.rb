module Brainclusterfuck
  module Lexer
    class << self
      def sanitize(string)
        string.gsub(/[^\[\]+\-><\.]/, '')
      end
    end
  end
end
