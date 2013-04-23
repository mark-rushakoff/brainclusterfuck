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

    def step(cycles_allowed = 1)
      raise ArgumentError, "cycles_allowed must be positive" unless cycles_allowed > 0

      while cycles_allowed > 0
        opcode = @bytecode[@instruction_pointer]

        unless opcode
          @finished = true
          return
        end

        cycles_allowed -= opcode.cycles
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
        Opcodes::LoopStart => :loop_start,
        Opcodes::LoopEnd => :loop_end,
        Opcodes::Print => :print
      }

      method = @op_to_method[opcode.class]
      raise ArgumentError, "Don't know how to handle #{opcode}" if method.nil?
      __send__(method, opcode)
      @finished = @instruction_pointer >= @bytecode.size
    end

    def modify_value(opcode)
      @memory.modify_value(opcode.modify_by)
      @instruction_pointer += 1
    end

    def modify_pointer(opcode)
      @memory.modify_pointer(opcode.modify_by)
      @instruction_pointer += 1
    end

    def print(_opcode)
      @terminal.print(@memory.current_char)
      @instruction_pointer += 1
    end

    def loop_start(opcode)
      if @memory.current_value.zero?
        @instruction_pointer += (opcode.num_operations + 2)
      else
        @instruction_pointer += 1
      end
    end

    def loop_end(opcode)
      if @memory.current_value.zero?
        @instruction_pointer += 1
      else
        @instruction_pointer -= opcode.num_operations
      end
    end
  end
end
