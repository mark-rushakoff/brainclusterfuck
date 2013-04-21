require 'brainclusterfuck/opcodes/loop_base'
require 'brainclusterfuck/opcodes/loop_end_placeholder'

module Brainclusterfuck::Opcodes
  class LoopEnd < LoopBase
    def placeholder_class
      LoopEndPlaceholder
    end
  end
end
