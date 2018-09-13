# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

require_relative 'detail/pattern_tokeniser'
require_relative 'detail/pattern'

$pattern = nil

def main
    Dir.glob( 'jcr_aor*.txt' ) { |fname| process_file fname }
end

def process_file fname
    line_num = 1
    File.foreach( fname ) { |line| process_line line_num, line; line_num += 1 }
end

def process_line line
    case line[0]
        when '?'
            parse_pattern line[1..-1]
        when '+'
            test_valid_instance line[1..-1]
        when '-'
            test_invalid_instance line[1..-1]
    end
end

def test_valid_instance line
    instance = Instance.new line
    puts instance[1]
    # TODO
end

def test_invalid_instance line
    # TODO
end

class Instance
    def initialize line
        @line = line.strip
        @line.gsub! /[^a-z]/, ''
    end
    def [] index
        index < @line.size ? @line[index] : ''
    end
end

main if __FILE__ == $PROGRAM_NAME
