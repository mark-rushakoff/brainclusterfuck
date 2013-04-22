module Brainclusterfuck
  class Interpreter
    attr_reader :terminal, :cells, :cycles, :instruction_pointer
    def initialize(opts)
      @terminal = opts.fetch(:terminal)
      @cells = opts.fetch(:cells)
      @bytecode = opts.fetch(:bytecode)

      @cycles = 0
      @instruction_pointer = 0
    end

    def step(cycles = 1)
      raise ArgumentError, "cycles must be positive" unless cycles > 0

      while cycles > 0
        opcode = @bytecode[@instruction_pointer]
        cycles -= opcode.cycles
        @cycles += opcode.cycles

        execute(opcode)
      end
    end

    private
    def execute(opcode)
      @op_to_method ||= {
        Opcodes::ModifyValue => :modify_value,
        Opcodes::ModifyPointer => :modify_pointer,
        Opcodes::Print => :print
      }

      method = @op_to_method[opcode.class]
      raise ArgumentError, "Don't know how to handle #{opcode}" if method.nil?
      __send__(method, opcode)
    end

    def modify_value(opcode)
      @cells.modify_value(opcode.modify_by)
    end

    def modify_pointer(opcode)
      @cells.modify_pointer(opcode.modify_by)
    end

    def print(_opcode)
      @terminal.print(@cells.current_char)
    end
  end
end
