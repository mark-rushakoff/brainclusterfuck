require 'spec_helper'
require 'brainclusterfuck/memory'

describe Brainclusterfuck::Memory do
  it 'initializes with a size' do
    expect(Brainclusterfuck::Memory.new(5).size).to eq(5)
  end
end
