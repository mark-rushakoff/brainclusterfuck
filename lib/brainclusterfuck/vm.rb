module Brainclusterfuck
  class VM
    attr_reader :input_code, :cells

    def initialize(instructions, num_cells)
      @input_code = Lexer.sanitize(instructions)
      @cells = Cells.new(num_cells)
    end
  end
end
