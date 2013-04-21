shared_examples 'a modifying opcode' do
  it 'stores the modify by and cycle count' do
    op = described_class.new(5, 8)

    expect(op.modify_by).to eq(5)
    expect(op.cycles).to eq(8)
  end

  it 'has correct equality behavior' do
    expect(described_class.new(1, 2)).to eq(described_class.new(1, 2))
    expect(described_class.new(1, 2)).not_to eq(described_class.new(1, 3))
  end

  describe 'squeezing' do
    it "can squeeze with another #{described_class}" do
      op1 = described_class.new(1, 1)
      op2 = described_class.new(1, 1)

      expect(op1.can_squeeze_with?(op2)).to eq(true)
      expect(op1.squeeze_with(op2)).to eq(described_class.new(2, 2))
    end

    it 'cannot squeeze with a generic opcode' do
      op = described_class.new(1, 1)
      expect(op.can_squeeze_with?(Brainclusterfuck::Opcodes::Base.new)).to eq(false)
    end

    it 'raises if trying to squeeze with an incompatible object' do
      op = described_class.new(1, 1)

      expect { op.squeeze_with(Brainclusterfuck::Opcodes::Base.new) }.to raise_error
    end
  end
end
