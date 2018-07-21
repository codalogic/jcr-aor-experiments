# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed

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

    it 'should ignore unwanted character input such as spaces' do
        tokeniser = PT.new "a b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Char )
        expect( token.c ).to eq( "b" )
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

    it 'should return a Kleene object for the second entity in "a?"' do
        tokeniser = PT.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Kleene )
    end

    it 'should return a [0,1] Kleene object for the second entity in "a?"' do
        tokeniser = PT.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Kleene )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( 1 )
    end

    it 'should return a [0,nil] Kleene object for the second entity in "a*"' do
        tokeniser = PT.new "a*"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Kleene )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a [1, nil] Kleene object for the second entity in "a+"' do
        tokeniser = PT.new "a+"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Kleene )
        expect( token.min ).to eq( 1 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a Int object for the second entity in "a23" at end of pattern' do
        tokeniser = PT.new "a23"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Int )
        expect( token.value ).to eq( 23 )
    end

    it 'should return a Int object for the second entity in "a23b" at middle of pattern' do
        tokeniser = PT.new "a23b"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( PT::Int )
        expect( token.value ).to eq( 23 )
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
end
