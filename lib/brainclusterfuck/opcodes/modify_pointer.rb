require 'brainclusterfuck/opcodes/modifying_base'

module Brainclusterfuck::Opcodes
  class ModifyPointer < ModifyingBase
    def can_squeeze_with?(other)
      super && (modify_by * other.modify_by) > 0 # same sign
    end
  end
end
