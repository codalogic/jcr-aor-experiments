# MIT Licensed:
#
# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
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
    def matches? c
        return @c == "." || c == @c
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
    undef :rep=
    undef :min
    undef :max
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
