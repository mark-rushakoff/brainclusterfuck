module Brainclusterfuck
  module Opcodes
    class Base
      attr_reader :cycles

      def can_squeeze_with?(other)
        false
      end

      def unresolve_loop
        self
      end

      def resolve_loop
        self
      end
    end
  end
end
