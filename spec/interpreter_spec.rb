require 'spec_helper'
require 'brainclusterfuck/interpreter'

describe Brainclusterfuck::Interpreter do
  let(:bytecode) { double(:bytecode, size: 5) }
  let(:terminal) { double(:terminal) }
  let(:memory) { double(:memory) }

  let(:interpreter) do
    described_class.new(
      bytecode: bytecode,
      terminal: terminal,
      memory: memory
    )
  end

  it 'exposes terminal and memory' do
    expect(interpreter.terminal).to equal(terminal)
    expect(interpreter.memory).to equal(memory)
  end

  it 'exposes cycles, starting at 0' do
    expect(interpreter.cycles).to eq(0)
  end

  it 'exposes the instruction pointer, starting at 0' do
    expect(interpreter.instruction_pointer).to eq(0)
  end

  describe '#step' do
    it 'raises if step is 0 or negative' do
      expect { interpreter.step(0) }.to raise_error(ArgumentError)
      expect { interpreter.step(-1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if attempting to execute an unknown opcode' do
      weird_opcode = Brainclusterfuck::Opcodes::Base.new
      weird_opcode.stub(cycles: 1)
      bytecode.should_receive(:[]).with(0).and_return(weird_opcode)

      expect { interpreter.step(1) }.to raise_error(ArgumentError)
    end

    it 'does nothing when stepping past a fully-executed program' do
      bytecode.should_receive(:[]).with(0).and_return(nil)

      interpreter.step(1)

      expect(interpreter).to be_finished
    end

    it 'will step exactly that number of cycles if possible' do
      bytecode.should_receive(:[]).with(0).and_return(Brainclusterfuck::Opcodes::ModifyValue.new(1, 1))
      memory.should_receive(:modify_value).with(1)

      interpreter.step(1)
      expect(interpreter.cycles).to eq(1)
    end

    it 'will step more than the asked cycles if necessary' do
      bytecode.should_receive(:[]).with(0).and_return(Brainclusterfuck::Opcodes::ModifyValue.new(1, 5))
      memory.should_receive(:modify_value).with(1)

      interpreter.step(1)
      expect(interpreter.cycles).to eq(5)
    end

    describe 'opcodes' do
      def set_up_bytecode(hash)
        hash.each do |index, op|
          bytecode.stub(:[]).with(index).and_return(op)
        end
      end

      it 'handles ModifyValue' do
        set_up_bytecode(0 => Brainclusterfuck::Opcodes::ModifyValue.new(1, 9))
        memory.should_receive(:modify_value).with(1)

        interpreter.step(1)
        expect(interpreter.cycles).to eq(9)
      end

      it 'handles ModifyValue' do
        set_up_bytecode(0 => Brainclusterfuck::Opcodes::ModifyPointer.new(1, 9))
        memory.should_receive(:modify_pointer).with(1)

        interpreter.step(1)
        expect(interpreter.cycles).to eq(9)
      end

      it 'handles Print' do
        set_up_bytecode(0 => Brainclusterfuck::Opcodes::Print.new)
        memory.stub(current_char: 'x')
        terminal.should_receive(:print).with('x')

        interpreter.step(1)
        expect(interpreter.cycles).to eq(1)
      end

      describe 'loops' do
        before do
          set_up_bytecode(
            0 => Brainclusterfuck::Opcodes::LoopStart.new(1),
            1 => Brainclusterfuck::Opcodes::ModifyPointer.new(1, 1),
            2 => Brainclusterfuck::Opcodes::LoopEnd.new(1),
            3 => Brainclusterfuck::Opcodes::ModifyValue.new(1, 1),
          )
        end

        describe 'LoopStart' do
          it 'stays in the loop when the current value is non-zero' do
            memory.stub(current_value: 1)
            memory.should_receive(:modify_pointer).with(1)
            memory.should_not_receive(:modify_value)

            interpreter.step(2)
            expect(interpreter.cycles).to eq(2)
          end

          it 'jumps past the end loop when the current value is zero' do
            memory.stub(current_value: 0)
            memory.should_receive(:modify_value).with(1)
            memory.should_not_receive(:modify_pointer)

            interpreter.step(2)
            expect(interpreter.cycles).to eq(2)
          end
        end

        describe 'LoopEnd' do
          it 'goes past the loop when the value is zero' do
            memory.stub(current_value: 1)
            memory.should_receive(:modify_pointer).with(1) do
              memory.stub(current_value: 0)
              memory.should_receive(:modify_value).with(1)
            end

            interpreter.step(4)

            expect(interpreter.cycles).to eq(4)
          end

          it 'goes back to the beginning of the loop when the value is non-zero' do
            memory.stub(current_value: 1)
            memory.should_receive(:modify_pointer).with(1).twice

            interpreter.step(4)
            expect(interpreter.cycles).to eq(4)
          end
        end
      end
    end
  end
end
