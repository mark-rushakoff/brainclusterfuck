require 'spec_helper'

describe 'Basic loops' do
  let(:lexer) { Brainclusterfuck::Lexer.new(program) }
  let(:compiler) { Brainclusterfuck::Compiler.new(lexer.tokens) }
  let(:terminal) { Brainclusterfuck::Terminal.new }
  let(:memory) { Brainclusterfuck::Memory.new(1) }

  let(:interpreter) do
    Brainclusterfuck::Interpreter.new(
      bytecode: compiler.bytecode,
      terminal: terminal,
      memory: memory
    )
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
