# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed

require 'rspec'

describe 'Tokeniser class' do
    it 'should be creatable' do
        tokeniser = Tokeniser.new "line"
        expect( 2 ).to eq( 2 )
    end

    it 'should return a Char object for the first entity in "a"' do
        tokeniser = Tokeniser.new "a"
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Char )
        expect( token.c ).to eq( "a" )
    end

    it 'should return a Char object for the second entity in "ab"' do
        tokeniser = Tokeniser.new "ab"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Char )
        expect( token.c ).to eq( "b" )
    end

    it 'should return a GroupStart object for the second entity in "a(c"' do
        tokeniser = Tokeniser.new "a(c"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::GroupStart )
    end

    it 'should return a GroupStart object for the third entity in "a()c"' do
        tokeniser = Tokeniser.new "a()c"
        token = tokeniser.next
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::GroupEnd )
    end

    it 'should return an End object for the third entity in "ab"' do
        tokeniser = Tokeniser.new "ab"
        token = tokeniser.next
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::End )
    end

    it 'should return a Rep object for the second entity in "a?"' do
        tokeniser = Tokeniser.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Rep )
    end

    it 'should return a [0,1] Rep object for the second entity in "a?"' do
        tokeniser = Tokeniser.new "a?"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Rep )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( 1 )
    end

    it 'should return a [0,nil] Rep object for the second entity in "a*"' do
        tokeniser = Tokeniser.new "a*"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Rep )
        expect( token.min ).to eq( 0 )
        expect( token.max ).to eq( nil )
    end

    it 'should return a [1, nil] Rep object for the second entity in "a+"' do
        tokeniser = Tokeniser.new "a+"
        token = tokeniser.next
        token = tokeniser.next
        expect( token ).to be_instance_of( Tokeniser::Rep )
        expect( token.min ).to eq( 1 )
        expect( token.max ).to eq( nil )
    end
end