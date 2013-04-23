require 'spec_helper'
require 'brainclusterfuck/memory'

describe Brainclusterfuck::Memory do
  let(:memory) { Brainclusterfuck::Memory.new(5) }
  it 'initializes with a size' do
    expect(memory.size).to eq(5)
  end

  it 'starts at value 0' do
    expect(memory.current_value).to eq(0)
  end

  it 'can modify the current value' do
    memory.modify_value(5)

    expect(memory.current_value).to eq(5)
  end

  it 'can modify the pointer' do
    memory.modify_value(5)

    memory.modify_pointer(1)
    expect(memory.current_value).to eq(0)

    memory.modify_pointer(-1)
    expect(memory.current_value).to eq(5)
  end
end
