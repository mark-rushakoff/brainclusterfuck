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
  end

  it 'converts tokens to the correct operations' do
    compiler = Brainclusterfuck::Compiler.new([:v_incr, :p_incr, :v_decr, :p_decr])
    expect(compiler.bytecode).to eq([
      Brainclusterfuck::Opcodes::ModifyValue.new(1, 1),
      Brainclusterfuck::Opcodes::ModifyPointer.new(1, 1),
      Brainclusterfuck::Opcodes::ModifyValue.new(-1, 1),
      Brainclusterfuck::Opcodes::ModifyPointer.new(-1, 1)
    ])
  end

  describe '#squeeze_operations' do
    it 'compresses the incr/decr operations' do
      tokens = (Array.new(8) { :v_incr }).concat(Array.new(3) { :p_decr })
      compiler = Brainclusterfuck::Compiler.new(tokens)
      compiler.squeeze_operations!

      expect(compiler.bytecode).to eq([
        Brainclusterfuck::Opcodes::ModifyValue.new(8, 8),
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
        Brainclusterfuck::Opcodes::ModifyPointer.new(-4, 8)
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
  end
end
