# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

class Pattern
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

def main
    Dir.glob( 'jcr-aor*.txt' ) { |fname| process fname }
end

def process fname
    File.foreach( fname ) do |line|
        case line[0]
            when '?'
                parse_pattern line
            when '+'
                test_valid_instance line
            when '-'
                test_invalid_instance line
            when '#'
                puts "Comment: ", line
        end
    end
end

pattern = nil

def parse_pattern line
end

instance = nil

def test_valid_instance line
    instance = Instance.new line
    puts instance[1]
end

def test_invalid_instance line
end

main if __FILE__ == $PROGRAM_NAME
