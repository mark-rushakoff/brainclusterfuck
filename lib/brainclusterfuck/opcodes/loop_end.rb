require 'brainclusterfuck/opcodes/base'
require 'brainclusterfuck/opcodes/loop_end_placeholder'

module Brainclusterfuck::Opcodes
  class LoopEnd < Base
    attr_reader :num_operations

    def initialize(num_operations)
      @num_operations = num_operations.to_i
      @cycles = 1
    end

    def ==(other)
      other.is_a?(LoopEnd) && other.num_operations == num_operations
    end

    def unresolve_loop
      LoopEndPlaceholder.new
    end
  end
end
