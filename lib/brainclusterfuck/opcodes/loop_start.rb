require 'brainclusterfuck/opcodes/base'
require 'brainclusterfuck/opcodes/loop_start_placeholder'

module Brainclusterfuck::Opcodes
  class LoopStart < Base
    attr_reader :num_operations

    def initialize(num_operations)
      @num_operations = num_operations.to_i
      @cycles = 1
    end

    def ==(other)
      other.is_a?(LoopStart) && other.num_operations == num_operations
    end

    def unresolve_loop
      LoopStartPlaceholder.new
    end
  end
end
