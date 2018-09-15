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
    def occurences
        @occurrences
    end
    def inc_occurences
        @occurences += 1
    end
end

module ValidatorGroupExclusions
    def exclusions
        @exclusions
    end
    def excluded? c
        @exclusions.include? c
    end
end

class Validator
    def initialize pattern
        @validator = make_validator pattern
    end
    def valid? instance
    end

    private def make_validator pattern
        validator = pattern.full_dup
        enhance validator
    end
    private def enhance g
        g.each do |sub|
            case sub
                when Member
                    sub.instance_variable_set( :@occurrences, 0 )
                    sub.extend ValidatorMemberExtensions
                when Group
                    sub.instance_variable_set( :@exclusions, [] )
                    sub.extend ValidatorGroupExclusions
                    enhance g
            end
        end
        g
    end
end
