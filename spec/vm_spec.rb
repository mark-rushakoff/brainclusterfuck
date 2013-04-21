require 'spec_helper'
require 'brainclusterfuck/vm'

describe Brainclusterfuck::VM do
  let(:instructions) { double(:instructions) }
  let(:cells) { double(:cells) }
  let(:terminal) { double(:terminal) }

  let(:vm) do
    Brainclusterfuck::VM.new(
      instructions: instructions,
      cells: cells,
      terminal: terminal
    )
  end

  it 'correctly reads from its option hash' do
    expect(vm.instructions).to eq(instructions)
    expect(vm.cells).to eq(cells)
    expect(vm.terminal).to eq(terminal)
  end
end
