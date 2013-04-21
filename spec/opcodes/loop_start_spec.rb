require 'spec_helper'
require 'brainclusterfuck/opcodes/loop_start'

describe Brainclusterfuck::Opcodes::LoopStart do
  let(:placeholder_class) { Brainclusterfuck::Opcodes::LoopStartPlaceholder }
  it_behaves_like 'a loop opcode'
end
