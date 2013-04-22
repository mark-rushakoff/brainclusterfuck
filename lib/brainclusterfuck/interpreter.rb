require 'brainclusterfuck/interpreter_error'

module Brainclusterfuck
  class Interpreter
    attr_reader :terminal, :memory, :cycles, :instruction_pointer, :finished
    def initialize(opts)
      @terminal = opts.fetch(:terminal)
      @memory = opts.fetch(:memory)
      @bytecode = opts.fetch(:bytecode)

      @cycles = 0
      @instruction_pointer = 0
    end

    def step(cycles = 1)
      raise ArgumentError, "cycles must be positive" unless cycles > 0

      while cycles > 0
        opcode = @bytecode[@instruction_pointer]

        unless opcode
          @finished = true
          return
        end

        cycles -= opcode.cycles
        @cycles += opcode.cycles

        execute(opcode)
      end
    end

    def finished?
      !!@finished
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
      @instruction_pointer += 1
      @@finished = @instruction_pointer >= @bytecode.size
    end

    def modify_value(opcode)
      @memory.modify_value(opcode.modify_by)
    end

    def modify_pointer(opcode)
      @memory.modify_pointer(opcode.modify_by)
    end

    def print(_opcode)
      @terminal.print(@memory.current_char)
    end
  end
end
