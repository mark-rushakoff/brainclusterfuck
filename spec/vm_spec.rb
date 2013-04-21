require 'spec_helper'
require 'brainclusterfuck/vm'

describe Brainclusterfuck::VM do
  describe '.input_code' do
    it 'is sanitized' do
      Brainclusterfuck::Lexer.should_receive(:sanitize).with('un+clean').and_return('+')

      expect(Brainclusterfuck::VM.new('un+clean', 0).input_code).to eq('+')
    end
  end

  describe '.cells' do
    it 'uses the size passed to the constructor' do
      mock_cells = double
      Brainclusterfuck::Cells.should_receive(:new).with(5).and_return(mock_cells)

      expect(Brainclusterfuck::VM.new('+', 5).cells).to eq(mock_cells)
    end
  end

  describe '.terminal' do
    it 'is a new Terminal object' do
      mock_terminal = double
      Brainclusterfuck::Terminal.should_receive(:new).with(no_args).and_return(mock_terminal)

      expect(Brainclusterfuck::VM.new('+', 5).terminal).to eq(mock_terminal)
    end
  end
end
