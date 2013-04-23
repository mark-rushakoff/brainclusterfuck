require 'spec_helper'
require 'brainclusterfuck/lexer'
require 'set'

describe Brainclusterfuck::Lexer do
  describe '#instruction_chars' do
    it 'strips out everything except the valid brainfuck instructions and keeps the order' do
      all_ascii_chars = (0..255).map { |n| n.chr }.join('')

      lexer = Brainclusterfuck::Lexer.new(all_ascii_chars)

      ordered_valid_chars = %w([ ] + - > < .).sort_by { |c| c.ord }
      expect(lexer.instruction_chars).to eq(ordered_valid_chars)
    end
  end

  describe '#tokens' do
    it 'tokenizes the input correctly' do
      # and doesn't validate the input
      lexer = Brainclusterfuck::Lexer.new('+>][<-.')
      expect(lexer.tokens).to eq([
        :v_incr,
        :p_incr,
        :loop_end,
        :loop_start,
        :p_decr,
        :v_decr,
        :print
      ])
    end
  end
end
