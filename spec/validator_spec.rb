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
        it 'should have status methods for a member' do
            v = Validator.new( Pattern.new 'abc' )
            expect( v[0].ok? ).to eq( false )
        end
        it 'should have status setting methods for a member' do
            v = Validator.new( Pattern.new 'abc' )
            v[0].status = true
            expect( v[0].ok? ).to eq( true )
        end
        it 'should have status methods for a child members' do
            v = Validator.new( Pattern.new 'a(b)c' )
            v[1][0].status = true
            expect( v[1][0].ok? ).to eq( true )
        end
    end

    context 'non-nested augmentation' do
        it 'should have no exclusions for a member in a sequence' do
            v = Validator.new( Pattern.new 'abc' )
            expect( v[0].exclusions.empty? ).to eq( true )
        end
        it 'should have exclusions for a member in a choice' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[0].exclusions.empty? ).to eq( false )
        end
        it 'should have exclusions for a second member in a choice' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[1].exclusions.empty? ).to eq( false )
        end
        it 'should have 2 exclusions for a first member in a choice' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[1].exclusions.size ).to eq( 2 )
        end
        it 'should exclude b & c for first member in choice a|b|c' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[0].excluded? 'b' ).to eq( true )
            expect( v[0].excluded? 'c' ).to eq( true )
        end
        it 'should not exclude a for first member in choice a|b|c' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[0].excluded? 'a' ).to eq( false )
        end
        it 'should exclude a & c for second member in choice a|b|c' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[1].excluded? 'a' ).to eq( true )
            expect( v[1].excluded? 'c' ).to eq( true )
        end
        it 'should not exclude b for second member in choice a|b|c' do
            v = Validator.new( Pattern.new 'a|b|c' )
            expect( v[1].excluded? 'b' ).to eq( false )
        end
    end

    context 'nested augmentation' do
        it 'should exclude nested b & d (& c) for first member in choice a|(bd)|c' do
            v = Validator.new( Pattern.new 'a|(bd)|c' )
            expect( v[0].excluded? 'b' ).to eq( true )
            expect( v[0].excluded? 'c' ).to eq( true )
            expect( v[0].excluded? 'd' ).to eq( true )
        end
        it 'should exclude nested a & c for second member in choice a|(bd)|c' do
            v = Validator.new( Pattern.new 'a|(bd)|c' )
            expect( v[1].excluded? 'a' ).to eq( true )
            expect( v[1].excluded? 'c' ).to eq( true )
        end
        it 'should exclude nested a & c for second member in choice a|(b|d)|c' do
            v = Validator.new( Pattern.new 'a|(b|d)|c' )
            expect( v[1].excluded? 'a' ).to eq( true )
            expect( v[1].excluded? 'c' ).to eq( true )
        end
        it 'should exclude d from member[1][0] in choice a|(b|d)|c' do
            v = Validator.new( Pattern.new 'a|(b|d)|c' )
            expect( v[1][0].excluded? 'd' ).to eq( true )
        end
        it 'should not exclude a from member[1][0] in choice a|(b|d)|c' do
            v = Validator.new( Pattern.new 'a|(b|d)|c' )
            expect( v[1][0].excluded? 'a' ).to eq( false )
        end
        it 'should exclude d & e from member[1][0] in choice a|(b|(de))|c' do
            v = Validator.new( Pattern.new 'a|(b|(de))|c' )
            expect( v[1][0].excluded? 'd' ).to eq( true )
            expect( v[1][0].excluded? 'e' ).to eq( true )
        end
        it 'should exclude a, b, d & e from member[2] in choice a|(b|(de))|c' do
            v = Validator.new( Pattern.new 'a|(b|(de))|c' )
            expect( v[2].excluded? 'a' ).to eq( true )
            expect( v[2].excluded? 'b' ).to eq( true )
            expect( v[2].excluded? 'd' ).to eq( true )
            expect( v[2].excluded? 'e' ).to eq( true )
        end
        it 'should exclude e from member[1][1][0] in choice a|(b|(d|e))|c' do
            v = Validator.new( Pattern.new 'a|(b|(d|e))|c' )
            expect( v[1][1][0].excluded? 'e' ).to eq( true )
        end
    end

    context 'basic validation' do
        it 'should say ab is valid in ab' do
            v = Validator.new( Pattern.new 'ab' )
            expect( v.valid? 'ab' ).to eq( true )
        end
    end
end
