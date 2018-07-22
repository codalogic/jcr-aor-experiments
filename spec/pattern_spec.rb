# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed
#
# For info see https://github.com/codalogic/jcr-aor-experiments

require 'rspec'

describe 'Pattern class' do
    context 'basic behaviour' do

        it 'should be creatable' do
            p = Pattern.new
        end

        it 'should be a kindof Group' do
            p = Pattern.new
            expect( p ).to be_kind_of( Group )
        end

        it 'should be a kindof Subordinate' do
            p = Pattern.new
            expect( p ).to be_kind_of( Group )
        end

        it 'should have a size' do
            p = Pattern.new
            expect( p.size ).to eq( 0 )
        end
    end
end
