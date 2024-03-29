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
      modifying_bytecode_length do
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
    end

    private
    def modifying_bytecode_length(&blk)
      unresolve_loops!
      yield
      resolve_loops!
    end

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

    def unresolve_loops!
      @bytecode.map! { |op| op.unresolve_loop }
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
  end
end
