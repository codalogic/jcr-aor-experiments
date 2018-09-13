# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

class Instance
    def initialize line
        @line = line.strip
        @line.gsub! /[^a-z]/, ''
    end
    def [] index
        index < @line.size ? @line[index] : ''
    end
end
