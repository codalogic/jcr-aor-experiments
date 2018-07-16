# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed

require 'spec_helper'
require 'rspec'
require_relative '../jcr-aor'

describe 'instance class' do
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
