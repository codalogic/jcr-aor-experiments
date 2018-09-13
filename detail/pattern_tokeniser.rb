# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
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
    class ChoiceSep end
    class GroupStart end
    class GroupEnd end
    class End end
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
