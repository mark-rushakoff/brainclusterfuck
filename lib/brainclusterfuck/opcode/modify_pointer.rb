module Brainclusterfuck
  class Opcode
    class ModifyPointer < Opcode
      attr_reader :modify_by, :cycles

      def initialize(modify_by, cycles)
        @modify_by = modify_by.to_i
        @cycles = cycles.to_i
      end

      def ==(other)
        other.is_a?(ModifyPointer) &&
          other.modify_by == modify_by &&
          other.cycles == cycles
      end

      def can_squeeze_with?(other)
        other.is_a?(ModifyPointer)
      end

      def squeeze_with(other)
        raise "Cannot squeeze: #{self}, #{other}" unless can_squeeze_with?(other)
        ModifyPointer.new(modify_by + other.modify_by, cycles + other.cycles)
      end
    end
  end
end
