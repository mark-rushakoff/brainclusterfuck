require 'brainclusterfuck/opcodes/base'

module Brainclusterfuck::Opcodes
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
  end
end
