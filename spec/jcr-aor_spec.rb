# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed

require 'rspec'
require_relative '../jcr-aor'

describe 'Instance class' do
    context 'basic behaviour' do
        instance = nil
        before do
            instance = Instance.new '+ab cd '
        end

        it 'should capture pass/fail status' do
            expect( instance.is_pass_expected ).to eq( true )
        end

        it 'should strip leading pass/fail status' do
            expect( instance[0] ).to eq( 'a' )
        end

        it 'should strip leading non-lower case alphabet characters' do
            expect( instance[2] ).to eq( 'c' )
        end

        it 'should return the empty string for indexes greater than the length of the string' do
            expect( instance[400] ).to eq( '' )
        end
    end
end

describe 'Pattern class' do
    context 'basic behaviour' do

        it 'should be created when parse_pattern method called' do
            parse_pattern "abc"
            expect( $pattern ).to be_instance_of( Pattern )
        end

        it 'should return the size of a single character base pattern' do
            parse_pattern "a"
            expect( $pattern.size ).to eq( 1 )
        end

        it 'should return the size of multiple character base pattern' do
            parse_pattern "abc"
            expect( $pattern.size ).to eq( 3 )
        end

        it 'should return the size of multiple character base pattern with spaces in it' do
            parse_pattern "a b c"
            expect( $pattern.size ).to eq( 3 )
        end

        #it 'when given an atomic node should say its atomic' do
        #    parse_pattern "a"
        #    expect( $pattern.is_atomic? ).to eq( true )
        #end
    end
end
