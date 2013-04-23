require 'brainclusterfuck/opcodes/base'
require 'brainclusterfuck/loop_error'

module Brainclusterfuck
  module Opcodes
    class LoopBase < Base
      attr_reader :num_operations

      def initialize(num_operations)
        @num_operations = num_operations.to_i
        @cycles = 1
      end

      def ==(other)
        other.class == self.class && other.num_operations == num_operations
      end

      def unresolve_loop
        placeholder_class.new
      end

      def resolve_loop
        raise LoopError, 'Loop already resolved'
      end
    end
  end
end
