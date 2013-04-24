require 'spec_helper'
require 'brainclusterfuck'

describe 'Basic loops' do
  let(:lexer) { Brainclusterfuck::Lexer.new(program) }
  let(:compiler) { Brainclusterfuck::Compiler.new(lexer.tokens) }
  let(:terminal) { Brainclusterfuck::Terminal.new }
  let(:memory) { Brainclusterfuck::Memory.new(10) }

  let(:interpreter) do
    Brainclusterfuck::Interpreter.new(
      bytecode: compiler.bytecode,
      terminal: terminal,
      memory: memory
    )
  end

  describe 'a nested loop' do
    let(:program) { '++[->++++[->++++<]<]>>.' }
    let(:expected_cycles) { 88 } # found and confirmed via experimentation :/

    def self.it_correctly_nests_loops
      it 'correctly nests loops' do
        interpreter.step(expected_cycles)
        expect(interpreter).to be_finished

        expect(interpreter.cycles).to eq(expected_cycles)
        expect(terminal.text).to eq(' ')
      end
    end

    context 'without optimizing' do
      it_correctly_nests_loops
    end

    context 'with optimizing' do
      before do
        compiler.squeeze_operations!
      end

      it_correctly_nests_loops
    end
  end

  describe 'the decrement macro' do
    let(:program) { '[-]' }
    let(:expected_cycles) do
      %w(
        open_loop
        decr
        end_loop
        decr
        end_loop
        decr
        end_loop
      ).size
    end

    def self.it_clears_the_cell
      it 'reduces the value of that cell to zero' do
        memory.modify_value(3)
        interpreter.step(expected_cycles)
        expect(interpreter).to be_finished

        expect(interpreter.cycles).to eq(expected_cycles)
        expect(memory.current_value).to eq(0)
      end
    end

    context 'without optimizing' do
      it_clears_the_cell
    end

    context 'with optimizing' do
      before do
        compiler.squeeze_operations!
      end

      it_clears_the_cell
    end
  end
end
