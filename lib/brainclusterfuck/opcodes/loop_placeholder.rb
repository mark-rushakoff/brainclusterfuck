require 'brainclusterfuck/opcodes/base'
require 'brainclusterfuck/loop_error'

module Brainclusterfuck
  module Opcodes
    class LoopPlaceholder < Base
      def initialize
        @cycles = 1
      end

      def unresolve_loop
        raise LoopError, "Already unresolved"
      end

      def ==(other)
        other.class == self.class
      end
    end
  end
end
