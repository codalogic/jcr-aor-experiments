# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

class Subordinate
    attr_reader :min, :max
    def rep= r
        @min, @max = r.min, r.max
    end
end

class Member < Subordinate
end

class Group < Subordinate
    def initialize
        @members = []
    end

    def size
        @members.size
    end
end

class Pattern < Group
end

def parse_pattern line
    $pattern = Pattern.new
end
