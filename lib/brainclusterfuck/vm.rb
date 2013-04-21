module Brainclusterfuck
  class VM
    attr_reader :input_code, :cells, :terminal

    def initialize(instructions, num_cells)
      @input_code = Lexer.sanitize(instructions)
      @cells = Cells.new(num_cells)
      @terminal = Terminal.new
    end
  end
end
