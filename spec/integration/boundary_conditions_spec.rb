require 'spec_helper'

describe 'Boundary conditions' do
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

  describe 'mismatched loop operators' do
    def self.it_raises
      it 'does not compile' do
        expect { interpreter }.to raise_error(Brainclusterfuck::CompileError)
      end
    end

    describe 'missing end' do
      let(:program) { '[+' }

      it_raises
    end

    describe 'missing start' do
      let(:program) { '+]' }

      it_raises
    end

    describe 'wrong order' do
      let(:program) { ']-[' }

      it_raises
    end
  end

  describe 'adjusting pointer out of bounds' do
    let(:program) { '<>>' }

    def self.it_raises
      it 'raises an exception' do
        expect { interpreter.step(3) }.to raise_error(Brainclusterfuck::MemoryError)
      end
    end

    context 'without optimizing' do
      it_raises
    end

    context 'when optimizing' do
      before do
        compiler.squeeze_operations!
      end

      it_raises
    end
  end

  describe 'overflowing memory value' do
    def self.it_rolls_over
      it 'rolls over' do
        interpreter.step(num_steps)
        expect(memory.current_value).to eq(255)
      end
    end

    describe 'going negative' do
      let(:program) { '-' }
      let(:num_steps) { 1 }

      context 'without optimizing' do
        it_rolls_over
      end

      context 'when optimizing' do
        before do
          compiler.squeeze_operations!
        end

        it_rolls_over
      end
    end

    describe 'going positive' do
      let(:program) { '+' * num_steps }
      let(:num_steps) { 255 + 256 }

      context 'without optimizing' do
        it_rolls_over
      end

      context 'when optimizing' do
        before do
          compiler.squeeze_operations!
        end

        it_rolls_over
      end
    end
  end
end
