require 'brainclusterfuck/opcodes/base'

module Brainclusterfuck::Opcodes
  class LoopEndPlaceholder < Base
    def initialize
      @cycles = 1
    end
  end
end
