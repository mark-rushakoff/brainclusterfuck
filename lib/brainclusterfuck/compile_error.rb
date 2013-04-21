module Brainclusterfuck
  class CompileError < RuntimeError
  end

  class UnterminatedLoopError < CompileError
  end

  class PrematurelyTerminatedLoopError < CompileError
  end
end
