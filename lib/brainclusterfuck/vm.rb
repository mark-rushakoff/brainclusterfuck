module Brainclusterfuck
  class VM
    attr_reader :input_code

    def initialize(instructions)
      @input_code = Lexer.sanitize(instructions)
    end
  end
end
