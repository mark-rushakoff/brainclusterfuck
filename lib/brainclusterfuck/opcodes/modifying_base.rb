require 'brainclusterfuck/opcodes/base'

module Brainclusterfuck::Opcodes
  class ModifyingBase < Base
    attr_reader :modify_by

    def initialize(modify_by, cycles)
      @modify_by = modify_by.to_i
      @cycles = cycles.to_i
    end

    def ==(other)
      other.class == self.class &&
        other.modify_by == modify_by &&
        other.cycles == cycles
    end

    def can_squeeze_with?(other)
      other.class == self.class
    end

    def squeeze_with(other)
      raise "Cannot squeeze: #{self}, #{other}" unless can_squeeze_with?(other)
      self.class.new(modify_by + other.modify_by, cycles + other.cycles)
    end
  end
end
