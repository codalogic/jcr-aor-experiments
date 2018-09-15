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

require_relative 'pattern'
require_relative 'instance'

require 'full_dup'

module ValidatorMemberExtensions
    def init
        @occurences = 0
    end
    def occurences
        @occurrences
    end
    def inc_occurences
        @occurences += 1
    end
end

module ValidatorGroupExclusions
    def init
        @exclusions = []
    end
    def exclusions
        @exclusions
    end
    def excluded? c
        @exclusions.include? c
    end
end

class Validator < Pattern
    def initialize pattern
        adopt_pattern pattern
        enhance
    end
    def valid? instance
    end

    private def adopt_pattern pattern
        pattern.instance_variables.each { |v| instance_variable_set( v, pattern.instance_variable_get( v ).full_dup ) }
    end

    private def enhance g = self
        g.each do |sub|
            case sub
                when Member
                    sub.extend ValidatorMemberExtensions
                    sub.init
                when Group
                    sub.extend ValidatorGroupExtensions
                    sub.init
                    enhance g
            end
        end
        g
    end

    private def each_member g = self, &b
        g.each do |sub|
            case sub
                when Member
                    yield sub
                when Group
                    each_member g, &b
            end
        end
        g
    end

    private def each_local_member g = self, &b
        g.each do |sub|
            case sub
                when Member
                    yield sub
            end
        end
        g
    end

    private def each_local_sub_group g = self, &b
        g.each do |sub|
            case sub
                when Group
                    yield sub
            end
        end
        g
    end
end
