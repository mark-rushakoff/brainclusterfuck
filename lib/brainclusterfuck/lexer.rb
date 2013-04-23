module Brainclusterfuck
  class Lexer
    attr_reader :instruction_chars, :tokens

    def initialize(instruction_string)
      @instruction_chars = sanitize(instruction_string).split('').freeze
      @tokens = tokenize(@instruction_chars)
    end

    private
    def sanitize(string)
      string.gsub(/[^\[\]+\-><\.]/, '')
    end

    def tokenize(instruction_chars)
      instruction_chars.map do |c|
        case c
        when '+'
          :v_incr
        when '-'
          :v_decr
        when '>'
          :p_incr
        when '<'
          :p_decr
        when '.'
          :print
        when '['
          :loop_start
        when ']'
          :loop_end
        else
          raise 'wtf?'
        end
      end
    end
  end
end
