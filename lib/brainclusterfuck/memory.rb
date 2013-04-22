module Brainclusterfuck
  class Memory
    attr_reader :size

    def initialize(size)
      @size = size.to_i
    end
  end
end
