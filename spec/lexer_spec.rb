require 'spec_helper'
require 'brainclusterfuck/lexer'
require 'set'

describe Brainclusterfuck::Lexer do
  describe '.sanitize' do
    it 'strips out everything except the valid brainfuck instructions' do
      all_ascii_chars = (0..255).map { |n| n.chr }.join('')

      instruction_chars = Brainclusterfuck::Lexer.sanitize(all_ascii_chars).each_char.to_a

      # and read from stdin (,) is not valid here
      expect(Set.new(instruction_chars)).to eq(Set.new(%w([ ] + - > < .)))
    end

    it 'keeps the order' do
      instructions = Brainclusterfuck::Lexer.sanitize('][+>.<-')
    end
  end
end
