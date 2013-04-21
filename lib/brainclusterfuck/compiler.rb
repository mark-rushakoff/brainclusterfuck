require 'brainclusterfuck/opcodes'
require 'brainclusterfuck/opcodes/loop_start_placeholder'
require 'brainclusterfuck/opcodes/loop_end_placeholder'
require 'brainclusterfuck/compile_error'

module Brainclusterfuck
  class Compiler
    attr_reader :bytecode
    def initialize(tokens)
      raise CompileError, "No tokens supplied" if tokens.size == 0

      @bytecode = tokens.map do |token|
        process_token(token)
      end

      resolve_loops!
    end

    # Merge consecutive modify value or modify pointer operations
    def squeeze_operations!
      compressed = [@bytecode.shift]

      @bytecode.each do |opcode|
        last = compressed[-1]
        if opcode.can_squeeze_with?(last)
          compressed[-1] = opcode.squeeze_with(last)
        else
          compressed << opcode
        end
      end

      @bytecode = compressed
    end

    private
    def resolve_loops!
      loop_stack = []

      @bytecode.each_with_index do |op, index|
        if op.is_a?(Opcodes::LoopStartPlaceholder)
          loop_stack.push(op: op, index: index)
        elsif op.is_a?(Opcodes::LoopEndPlaceholder)
          raise PrematurelyTerminatedLoopError if loop_stack.empty?

          opening = loop_stack.pop
          num_operations = index - opening[:index] - 1
          @bytecode[opening[:index]] = Opcodes::LoopStart.new(num_operations)
          @bytecode[index] = Opcodes::LoopEnd.new(num_operations)
        end
      end

      raise UnterminatedLoopError unless loop_stack.empty?
    end

    def process_token(token)
      case token
      when :v_incr
        Opcodes::ModifyValue.new(1, 1)
      when :v_decr
        Opcodes::ModifyValue.new(-1, 1)
      when :p_incr
        Opcodes::ModifyPointer.new(1, 1)
      when :p_decr
        Opcodes::ModifyPointer.new(-1, 1)
      when :print
        Opcodes::Print.new
      when :loop_start
        Opcodes::LoopStartPlaceholder.new
      when :loop_end
        Opcodes::LoopEndPlaceholder.new
      else
        raise CompileError, "Don't know how to handle token: #{token}"
      end
    end

    def compress_bytecode(bytecode)
      compressed = [bytecode.shift]

      bytecode.each do |op, value|
        case op
        when :modify_value, :modify_pointer
          if compressed[-1][0] == op
            compressed[-1][1] += value
          else
            compressed << [op, value]
          end
        end
      end

      compressed
    end
  end
end
