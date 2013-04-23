require 'spec_helper'

describe 'Printing simple text' do
  let(:lexer) { Brainclusterfuck::Lexer.new(program) }
  let(:compiler) { Brainclusterfuck::Compiler.new(lexer.tokens) }
  let(:terminal) { Brainclusterfuck::Terminal.new }
  let(:memory) { Brainclusterfuck::Memory.new(5) }

  let(:interpreter) do
    Brainclusterfuck::Interpreter.new(
      bytecode: compiler.bytecode,
      terminal: terminal,
      memory: memory
    )
  end

  describe 'printing "!"' do
    let(:program) { ('+' * 33) + '.' }

    def self.it_prints
      it 'sends "!" to the terminal object' do
        interpreter.step(35)
        expect(interpreter).to be_finished
        expect(interpreter.cycles).to eq(34) # 33 increments + 1 print
        expect(terminal.text).to eq('!')
      end
    end

    context 'without optimizing' do
      it_prints
    end

    context 'when optimizing' do
      before do
        compiler.squeeze_operations!
      end

      it_prints
    end
  end
end
