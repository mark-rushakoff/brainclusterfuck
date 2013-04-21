require 'spec_helper'
require 'brainclusterfuck/cells'

describe Brainclusterfuck::Cells do
  it 'initializes with a size' do
    expect(Brainclusterfuck::Cells.new(5).size).to eq(5)
  end
end
