require 'brainclusterfuck/memory_error'

module Brainclusterfuck
  class Memory
    attr_reader :size

    def initialize(size)
      @size = size.to_i

      @pointer = 0
      @cells = Hash.new { 0 }
    end

    def current_char
      current_value.chr
    end

    def current_value
      @cells[@pointer]
    end

    def modify_value(amount)
      # keep value in one byte
      @cells[@pointer] = (@cells[@pointer] + amount.to_i) & 0xFF
    end

    def modify_pointer(amount)
      @pointer += amount

      raise MemoryError if (@pointer < 0 || @pointer >= @size)
    end
  end
end
