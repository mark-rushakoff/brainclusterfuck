module Brainclusterfuck
  class Terminal
    attr_reader :text

    def initialize
      @text = ''
    end

    def print(char)
      @text << char
    end
  end
end
