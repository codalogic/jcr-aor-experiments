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
require 'set'

module ValidatorOccurrencesMixin
    def init_occurrences
        @occurrences = 0
    end
    def occurrences
        @occurrences
    end
    def inc_occurrences
        @occurrences += 1
    end
end

module ValidatorExclusionsMixin
    def init_exclusions
        @exclusions = Set.new
    end
    def exclusions= e
        @exclusions = e
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
        augment_choices
    end
    def valid? instance
    end

    private def adopt_pattern pattern
        pattern.instance_variables.each { |v| instance_variable_set( v, pattern.instance_variable_get( v ).full_dup ) }
    end

    private def enhance g = self
        g.each do |sub|
            sub.extend ValidatorExclusionsMixin
            sub.init_exclusions

            case sub
                when Member
                    sub.extend ValidatorOccurrencesMixin
                    sub.init_occurrences
                when Group
                    enhance sub
            end
        end
        g
    end

    private def augment_choices g = self
        if g.choice?
            all_group_members = all_member_names g
            each do |sub|
                all_sub_members = all_member_names sub
                sub.exclusions = all_group_members - all_sub_members
            end
        end
        each_local_sub_group( g ) { |sub| augment_choices sub }
    end

    private def all_member_names sub = self
        every_child_member = Set.new
        if sub.instance_of? Member
            every_child_member << sub.c
        else
            each_member { |m| every_child_member << m.c }
        end
        every_child_member
    end

    private def each_member g = self, &b
        g.each do |sub|
            case sub
                when Member
                    yield sub
                when Group
                    each_member sub, &b
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
