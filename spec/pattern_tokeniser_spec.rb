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

describe 'PatternTokeniser class' do

    PT = PatternTokeniser

    it 'should be creatable' do
        tokeniser = PT.new "line"
        expect( 2 ).to eq( 2 )
    end

    it 'should return a Char object for the first entity in "a"' do
        tokeniser = PT.new "a"
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "a" )
    end

    it 'should return a Char object for the second entity in "ab"' do
        tokeniser = PT.new "ab"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should return a Char object for the wildcard entity in "a."' do
        tokeniser = PT.new "a."
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "." )
    end

    it 'should return a ChoiceSep object for the second entity in "a|c"' do
        tokeniser = PT.new "a|c"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::ChoiceSep )
    end

    it 'should return a GroupStart object for the second entity in "a(c"' do
        tokeniser = PT.new "a(c"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::GroupStart )
    end

    it 'should return a GroupStart object for the third entity in "a()c"' do
        tokeniser = PT.new "a()c"
        token = tokeniser.next
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::GroupEnd )
    end

    it 'should return a Rep object for the second entity in "a?"' do
        tokeniser = PT.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
    end

    it 'should return a [0,1] Rep object for the second entity in "a?"' do
        tokeniser = PT.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( 1 )
    end

    it 'should return a [0,nil] Rep object for the second entity in "a*"' do
        tokeniser = PT.new "a*"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a [1, nil] Rep object for the second entity in "a+"' do
        tokeniser = PT.new "a+"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 1 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a Rep object for the second entity in "a23" at end of pattern' do
        tokeniser = PT.new "a23"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( 23 )
    end

    it 'should return a Rep object for the second entity in "a23b" at middle of pattern' do
        tokeniser = PT.new "a23b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( 23 )
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should return a Rep object with unbounded max for the second entity in "a23~" at end of pattern' do
        tokeniser = PT.new "a23~"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a Rep object with unbounded max for the second entity in "a23~b" in middle of pattern' do
        tokeniser = PT.new "a23~b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( nil )
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should return a Rep object with specific max for the second entity in "a23~100" at end of pattern' do
        tokeniser = PT.new "a23~100"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( 100 )
    end

    it 'should return a Rep object with specific max for the second entity in "a23~100b" in middle of pattern' do
        tokeniser = PT.new "a23~100b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Rep )
        expect( token.min ).to eq( 23 )
        expect( token.max ).to eq( 100 )
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should return an End object for the third entity in "ab"' do
        tokeniser = PT.new "ab"
        token = tokeniser.next
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::End )
    end

    it 'should be able to repeatedly call next after End object has been returned' do
        tokeniser = PT.new "ab"
        token = tokeniser.next
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::End )
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::End )
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::End )
    end

    it 'should ignore unwanted whitespace in middle of string' do
        tokeniser = PT.new "a b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should ignore unwanted whitespace at end of string' do
        tokeniser = PT.new "a "
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::End )
    end

    it 'should return an Illegal object for unwanted symbols' do
        tokeniser = PT.new "a&"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Illegal )
        expect( token.index ).to eq( 1 )
    end
end
