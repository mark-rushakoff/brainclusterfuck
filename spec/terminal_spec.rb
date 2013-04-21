require 'spec_helper'
require 'brainclusterfuck/terminal'

describe Brainclusterfuck::Terminal do
  it 'starts with empty text' do
    expect(Brainclusterfuck::Terminal.new.text).to eq('')
  end
end
