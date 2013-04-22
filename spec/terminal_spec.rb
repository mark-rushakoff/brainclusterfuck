require 'spec_helper'
require 'brainclusterfuck/terminal'

describe Brainclusterfuck::Terminal do
  it 'starts with empty text' do
    expect(Brainclusterfuck::Terminal.new.text).to eq('')
  end

  it 'can print' do
    terminal = Brainclusterfuck::Terminal.new
    terminal.print('a')

    expect(terminal.text).to eq('a')

    terminal.print('b')

    expect(terminal.text).to eq('ab')
  end
end
