require 'brainclusterfuck/opcode/modify_value'
require 'brainclusterfuck/opcode/modify_pointer'

module Brainclusterfuck
  class Compiler
    attr_reader :bytecode
    def initialize(tokens)
      raise "No tokens supplied" if tokens.size == 0

      @bytecode = tokens.map do |token|
        process_token(token)
      end
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
    def process_token(token)
      case token
      when :v_incr
        Opcode::ModifyValue.new(1, 1)
      when :v_decr
        Opcode::ModifyValue.new(-1, 1)
      when :p_incr
        Opcode::ModifyPointer.new(1, 1)
      when :p_decr
        Opcode::ModifyPointer.new(-1, 1)
      else
        raise 'wtf'
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
