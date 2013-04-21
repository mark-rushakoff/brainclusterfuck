require 'spec_helper'
require 'brainclusterfuck/opcode'

describe Brainclusterfuck::Opcode do
  describe '#can_squeeze_with?' do
    it 'is false' do
      expect(described_class.new.can_squeeze_with?(described_class.new)).to eq(false)
    end
  end
end
