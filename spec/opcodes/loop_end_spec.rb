require 'spec_helper'
require 'brainclusterfuck/opcodes/loop_end'

describe Brainclusterfuck::Opcodes::LoopEnd do
  let(:placeholder_class) { Brainclusterfuck::Opcodes::LoopEndPlaceholder }
  it_behaves_like 'a loop opcode'
end
