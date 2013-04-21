require 'spec_helper'
require 'brainclusterfuck/opcodes/loop_start'

describe Brainclusterfuck::Opcodes::LoopStart do
  it 'has num_operations' do
    op = described_class.new(3)

    expect(op.num_operations).to eq(3)
  end

  it 'uses equality' do
    expect(described_class.new(1)).to eq(described_class.new(1))
    expect(described_class.new(1)).not_to eq(described_class.new(2))
  end

  it 'can unresolve' do
    expect(described_class.new(1).unresolve_loop).to be_a(Brainclusterfuck::Opcodes::LoopStartPlaceholder)
  end
end
