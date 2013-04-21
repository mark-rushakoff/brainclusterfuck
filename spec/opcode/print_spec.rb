require 'spec_helper'
require 'brainclusterfuck/opcode/print'

describe Brainclusterfuck::Opcode::Print do
  it 'has 1 cycle' do
    expect(described_class.new.cycles).to eq(1)
  end

  it 'has correct equality behavior' do
    expect(described_class.new).to eq(described_class.new)
    expect(described_class.new).not_to eq(Brainclusterfuck::Opcode.new)
  end
end
