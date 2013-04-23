require 'brainclusterfuck/loop_error'

shared_examples 'a loop placeholder' do
  it 'uses equality' do
    expect(described_class.new).to eq(described_class.new)
    expect(described_class.new).not_to eq(Brainclusterfuck::Opcodes::Base.new)
  end

  it 'raises on unresolve' do
    expect { described_class.new.unresolve_loop }.to raise_error(Brainclusterfuck::LoopError)
  end
end
