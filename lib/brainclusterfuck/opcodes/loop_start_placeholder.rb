require 'brainclusterfuck/opcodes/base'

module Brainclusterfuck::Opcodes
  class LoopStartPlaceholder < Base
    def initialize
      @cycles = 1
    end
  end
end
