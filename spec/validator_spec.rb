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

require 'rspec'
require_relative '../jcr_aor'

describe 'Validator class' do
    context 'basic behaviour' do

        it 'should be creatable' do
            v = Validator.new Pattern.new
        end
        it 'should have a size method' do
            v = Validator.new( Pattern.new 'abc' )
            expect( v.size ).to eq( 3 )
        end
    end
    context 'method enhancements' do
        it 'should have occurences methods for a member' do
            v = Validator.new( Pattern.new 'abc' )
            expect( v[0].occurrences ).to eq( 0 )
        end
        it 'should have inc_occurrences methods for a member' do
            v = Validator.new( Pattern.new 'abc' )
            v[0].inc_occurrences
            expect( v[0].occurrences ).to eq( 1 )
        end
        it 'should have inc_occurrences methods for a child members' do
            v = Validator.new( Pattern.new 'a(b)c' )
            v[1][0].inc_occurrences
            expect( v[1][0].occurrences ).to eq( 1 )
        end
        it 'should have exclusions methods for a member' do
            v = Validator.new( Pattern.new 'abc' )
            expect( v[0].exclusions.empty? ).to eq( true )
        end
        it 'should have exclusions methods for a group' do
            v = Validator.new( Pattern.new '(abc)' )
            expect( v[0].exclusions.empty? ).to eq( true )
        end
        it 'should have exclusions methods for a child member' do
            v = Validator.new( Pattern.new 'a(b)c' )
            expect( v[1][0].exclusions.empty? ).to eq( true )
        end
        it 'should have exclusions methods for a child group' do
            v = Validator.new( Pattern.new 'a((b))c' )
            expect( v[1][0].exclusions.empty? ).to eq( true )
        end
    end
end
