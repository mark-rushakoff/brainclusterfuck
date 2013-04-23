require 'spec_helper'
require 'brainclusterfuck/compiler'
require 'brainclusterfuck/compile_error'
require 'brainclusterfuck/opcodes'

describe Brainclusterfuck::Compiler do
  describe 'invalid token streams' do
    it 'raises if there are no tokens' do
      expect { Brainclusterfuck::Compiler.new([]) }.to raise_error(Brainclusterfuck::CompileError)
    end

    it 'raises if there are unrecognized tokens' do
      expect { Brainclusterfuck::Compiler.new([:foo]) }.to raise_error(Brainclusterfuck::CompileError)
    end

    it 'raises if an end loop occurs before an open loop' do
      expect { Brainclusterfuck::Compiler.new([:loop_end]) }.to raise_error(Brainclusterfuck::PrematurelyTerminatedLoopError)
    end

    it 'raises if an open loop does not have an end loop' do
      expect { Brainclusterfuck::Compiler.new([:loop_start]) }.to raise_error(Brainclusterfuck::UnterminatedLoopError)
    end

    it 'raises if there are too many end loops' do
      expect { Brainclusterfuck::Compiler.new([:loop_start, :loop_end, :loop_end]) }.to raise_error(Brainclusterfuck::PrematurelyTerminatedLoopError)
    end

    it 'raises if there are not enough open loops' do
      expect { Brainclusterfuck::Compiler.new([:loop_start, :loop_start, :loop_end]) }.to raise_error(Brainclusterfuck::UnterminatedLoopError)
    end
  end

  it 'converts tokens to the correct operations' do
    compiler = Brainclusterfuck::Compiler.new([:v_incr, :p_incr, :loop_start, :v_decr, :loop_end, :p_decr, :print])
    expect(compiler.bytecode).to eq([
      Brainclusterfuck::Opcodes::ModifyValue.new(1, 1),
      Brainclusterfuck::Opcodes::ModifyPointer.new(1, 1),
      Brainclusterfuck::Opcodes::LoopStart.new(1),
      Brainclusterfuck::Opcodes::ModifyValue.new(-1, 1),
      Brainclusterfuck::Opcodes::LoopEnd.new(1),
      Brainclusterfuck::Opcodes::ModifyPointer.new(-1, 1),
      Brainclusterfuck::Opcodes::Print.new
    ])
  end

  describe '#squeeze_operations' do
    it 'compresses the lone incr/decr operations' do
      tokens = (Array.new(8) { :v_incr }).concat(Array.new(3) { :p_decr })
      compiler = Brainclusterfuck::Compiler.new(tokens)
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::ModifyValue.new(8, 8),
        Brainclusterfuck::Opcodes::ModifyPointer.new(-3, 3)
      ])
    end

    it 'merges opposite-direction value modifiers' do
      tokens = (Array.new(8) { :v_incr }).concat(Array.new(3) { :v_decr })
      compiler = Brainclusterfuck::Compiler.new(tokens)
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::ModifyValue.new(5, 11)
      ])
    end

    it 'does not merge opposite-direction pointer modifiers' do
      tokens = (Array.new(8) { :p_incr }).concat(Array.new(3) { :p_decr })
      compiler = Brainclusterfuck::Compiler.new(tokens)
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::ModifyPointer.new(8, 8),
        Brainclusterfuck::Opcodes::ModifyPointer.new(-3, 3)
      ])
    end

    it 'correctly retains cycles' do
      tokens = (Array.new(3) { :v_incr }).
        concat([:v_decr]).
        concat(Array.new(6) { :p_decr }).
        concat(Array.new(2) { :p_incr })

      compiler = Brainclusterfuck::Compiler.new(tokens)
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::ModifyValue.new(2, 4),
        Brainclusterfuck::Opcodes::ModifyPointer.new(-6, 6),
        Brainclusterfuck::Opcodes::ModifyPointer.new(2, 2)
      ])
    end

    it 'does not squeeze prints' do
      compiler = Brainclusterfuck::Compiler.new(Array.new(3) { :print })
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::Print.new,
        Brainclusterfuck::Opcodes::Print.new,
        Brainclusterfuck::Opcodes::Print.new
      ])
    end

    it 'handles loops properly' do
      compiler = Brainclusterfuck::Compiler.new([
        :loop_start,
        :v_decr,
        :v_decr,
        :v_decr,
        :loop_end
      ])

      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::LoopStart.new(1),
        Brainclusterfuck::Opcodes::ModifyValue.new(-3, 3),
        Brainclusterfuck::Opcodes::LoopEnd.new(1)
      ])
    end
  end
end
