require 'spec_helper'

describe 'A brainfuck program that just prints "!"' do
  let(:program) { ('+' * 33) + '.' }
  let(:lexer) { Brainclusterfuck::Lexer.new(program) }
  let(:compiler) { Brainclusterfuck::Compiler.new(lexer.tokens) }
  let(:terminal) { Brainclusterfuck::Terminal.new }
  let(:memory) { Brainclusterfuck::Memory.new(5) }

  let(:interpreter) do
    Brainclusterfuck::Interpreter.new(
      bytecode: compiler.bytecode,
      terminal: terminal,
      memory: memory
    )
  end

  it 'sends "!" to the terminal object without optimizing' do
    interpreter.step(35)
    expect(interpreter).to be_finished
    expect(interpreter.cycles).to eq(34) # 33 increments + 1 print
    expect(terminal.text).to eq('!')
  end
end
