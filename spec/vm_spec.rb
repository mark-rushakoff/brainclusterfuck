require 'spec_helper'
require 'brainclusterfuck/vm'

describe Brainclusterfuck::VM do
  describe '.input_code' do
    it 'is sanitized' do
      Brainclusterfuck::Lexer.should_receive(:sanitize).with('un+clean').and_return('+')

      expect(Brainclusterfuck::VM.new('un+clean').input_code).to eq('+')
    end
  end
end
