# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

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
    end

    def << ( m )
        @members << m
    end

    def size
        @members.size
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

def parse_pattern line
    $pattern = Pattern.new
end
