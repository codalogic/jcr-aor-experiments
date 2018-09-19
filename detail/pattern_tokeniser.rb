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

class PatternTokeniser
    class Char
        attr_reader :c
        def initialize c
            @c = c
        end
    end
    class Rep
        @@kleene_min_max_mappings = { '?' => [0, 1], '*' => [0, nil], '+' => [1, nil] }
        attr_reader :min, :max
        def initialize c_or_min, max = nil
            if c_or_min.instance_of? String
                @min, @max = @@kleene_min_max_mappings.fetch( c_or_min, [1,1] )
            else
                @min, @max = c_or_min, max
            end
        end
    end
    class ChoiceSep; end
    class GroupStart; end
    class GroupEnd; end
    class End; end
    class Illegal
        attr_reader :index, :c
        def initialize index, c
            @index, @c = index, c
        end
    end

    def initialize line
        @line = line
        @index = 0
    end

    def index
        @index
    end

    def c
        @line[@index]
    end

    def next
        skip_ws
        return End.new if @index >= @line.length
        case @line[@index]
            when /[a-z\.]/
                r = Char.new @line[@index]
                @index += 1
                r
            when /[?*+]/
                r = Rep.new @line[@index]
                @index += 1
                r
            when /\d/
                explicit_reps
            when '|'
                @index += 1
                ChoiceSep.new
            when '('
                @index += 1
                GroupStart.new
            when ')'
                @index += 1
                GroupEnd.new
            else
                r = Illegal.new @index, @line[@index]
                @index += 1
                r
        end
    end

    private def skip_ws
        @index += 1 while @line[@index] =~ /\s/
    end

    private def explicit_reps
        min = max = parse_integer
        if @line[@index] == '~'
            max = nil
            @index += 1
            if @line[@index] =~ /\d/
                max = parse_integer
            end
        end
        Rep.new min, max
    end

    private def parse_integer
        value = ''
        while @line[@index] =~ /\d/
            value += @line[@index]
            @index += 1
        end
        value.to_i
    end
end
