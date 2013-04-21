require 'spec_helper'
require 'brainclusterfuck/opcodes/base'

describe Brainclusterfuck::Opcodes::Base do
  describe '#can_squeeze_with?' do
    it 'is false' do
      expect(described_class.new.can_squeeze_with?(described_class.new)).to eq(false)
    end
  end

  describe '#unresolve_loop' do
    it 'returns self' do
      op = described_class.new

      expect(op.unresolve_loop).to equal(op)
    end
  end
end
