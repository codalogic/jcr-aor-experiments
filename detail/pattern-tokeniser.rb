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
    class Kleene
        @@kleene_min_max_mappings = { '?' => [0, 1], '*' => [0, nil], '+' => [1, nil] }
        attr_reader :min, :max
        def initialize c
            @min, @max = @@kleene_min_max_mappings.fetch( c, [1,1] )
        end
    end
    class ChoiceSep end
    class GroupStart end
    class GroupEnd end
    class End end

    def initialize line
        @line = line.gsub /[^a-z0-9*+?()|]/, ''
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
                r = Kleene.new @line[@index]
                @index += 1
                r
            when '|'
                @index += 1
                ChoiceSep.new
            when '('
                @index += 1
                GroupStart.new
            when ')'
                @index += 1
                GroupEnd.new
        end
    end
end
