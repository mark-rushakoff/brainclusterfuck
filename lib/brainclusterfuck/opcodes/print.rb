require 'brainclusterfuck/opcodes/base'

module Brainclusterfuck::Opcodes
  class Print < Base
    def initialize
      @cycles = 1
    end

    def ==(other)
      other.is_a?(Print)
    end
  end
end
