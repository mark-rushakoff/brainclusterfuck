module Brainclusterfuck
  module Opcodes
    class Base
      attr_reader :cycles

      def can_squeeze_with?(other)
        false
      end
    end
  end
end
