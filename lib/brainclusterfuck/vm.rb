module Brainclusterfuck
  class VM
    attr_reader :instructions, :cells, :terminal

    def initialize(opts)
      @instructions = opts.fetch(:instructions)
      @cells = opts.fetch(:cells)
      @terminal = opts.fetch(:terminal)
    end
  end
end
