# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

class Tokeniser
    class Char
        attr_reader :c
        def initialize c
            @c = c
        end
    end
    class Rep
        @@kleene_min_max_mappings = { '?' => [0, 1], '*' => [0, nil], '+' => [1, nil] }
        attr_reader :min, :max
        def initialize c
            @min, @max = @@kleene_min_max_mappings.fetch( c, [1,1] )
        end
    end
    class GroupStart end
    class GroupEnd end
    class End end

    def initialize line
        @line = line
        @index = 0
    end
    def next
        return End.new if @index >= @line.length
        case @line[@index]
            when /[a-z]/
                r = Char.new @line[@index]
                @index += 1
                r
            when /[?*+]/
                r = Rep.new @line[@index]
                @index += 1
                r
            when '('
                @index += 1
                GroupStart.new
            when ')'
                @index += 1
                GroupEnd.new
        end
    end
end
