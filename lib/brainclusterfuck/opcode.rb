require 'brainclusterfuck/opcode/modify_value'

module Brainclusterfuck
  class Opcode
    attr_reader :cycles

    def can_squeeze_with?(other)
      false
    end
  end
end
