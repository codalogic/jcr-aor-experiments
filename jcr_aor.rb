# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

require_relative 'detail/pattern_tokeniser'

$pattern = nil

def main
    Dir.glob( 'jcr_aor*.txt' ) { |fname| process_file fname }
end

def process_file fname
    File.foreach( fname ) { |line| process_line line }
end

def process_line line
    case line[0]
        when '?'
            parse_pattern line
        when '+'
            test_valid_instance line
        when '-'
            test_invalid_instance line
    end
end

def parse_pattern line
    $pattern = Pattern.new line
end

class Pattern
    def initialize line
        @nodes = []
        line.gsub( /[^a-z0-9*+?()|]/, '' ).each_char { |c| @nodes << (PatternNode.new c) }
    end

    def size
        @nodes.size
    end
end

class PatternNode
    # Pass atomic character for an atomic node, or 'nothing' to start group node
    def initialize c = nil
        @is_atomic = ! c.nil?
    end

    def is_atomic?
        @is_atomic
    end
end

class PatternNode
end

def test_valid_instance line
    instance = Instance.new line
    puts instance[1]
end

def test_invalid_instance line
end

class Instance
    def initialize line
        @line = line.strip
        @is_pass_expected = (@line[0] == '+')
        @line.gsub! /[^a-z]/, ''
    end
    def is_pass_expected
        @is_pass_expected
    end
    def [] index
        index < @line.size ? @line[index] : ''
    end
end

main if __FILE__ == $PROGRAM_NAME
