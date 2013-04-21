module Brainclusterfuck
  class Opcode
    class Print < Opcode
      def initialize
        @cycles = 1
      end

      def ==(other)
        other.is_a?(Print)
      end
    end
  end
end
