# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

require_relative 'pattern_tokeniser'

class Subordinate
    attr_reader :min, :max
    def initialize
        @min = @max = 1
    end

    def rep= r
        @min, @max = r.min, r.max
    end
end

class Member < Subordinate
    attr_reader :c
    def initialize c
        super()
        @c = c
    end
end

class Group < Subordinate
    def initialize
        super()
        @members = []
        @is_choice = false
    end

    def choice
        @is_choice = true
    end

    def sequence?
        ! @is_choice
    end

    def choice?
        @is_choice
    end

    def << ( m )
        @members << m
    end

    def size
        @members.size
    end

    def back
        @members[-1]
    end

    def [] ( i )
        @members[i]
    end

    def each &b
        @members.each &b
    end
end

class Pattern < Group
    private def rep=; end
    private def min; end
    private def max; end
end

class PatternParser
    def initialize line
        @line = line
        $pattern = Pattern.new
        @pt = PatternTokeniser.new line
        parse_group $pattern
    end

    private def parse_group g
        loop do
            case t = @pt.next
                when PatternTokeniser::Char
                    g << Member.new( t.c )
                when PatternTokeniser::Rep
                    g.back.rep = t
                when PatternTokeniser::ChoiceSep
                    g.choice
                when PatternTokeniser::GroupStart
                    g << Group.new
                    parse_group g.back
                when PatternTokeniser::GroupEnd
                    raise "Unmatched closing bracket at index #{@pt.index-1}" if g.instance_of? Pattern
                    return
                when PatternTokeniser::End
                    raise "Unexpected end of pattern" if ! g.instance_of? Pattern
                    break
                when PatternTokeniser::Illegal
                    raise "Illegal character '#{t.c}' at index #{t.index}"
            end
        end
    end
end

def parse_pattern_with_exceptions line
    PatternParser.new line
end

def parse_pattern line_num, line
    begin
        parse_pattern_with_exceptions line

    rescue StandardError => e
        puts "Error (line #{line_num}): #{e.message}"
    end
end
