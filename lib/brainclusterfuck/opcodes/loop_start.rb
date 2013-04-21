require 'brainclusterfuck/opcodes/loop_base'
require 'brainclusterfuck/opcodes/loop_start_placeholder'

module Brainclusterfuck::Opcodes
  class LoopStart < LoopBase
    def placeholder_class
      LoopStartPlaceholder
    end
  end
end
