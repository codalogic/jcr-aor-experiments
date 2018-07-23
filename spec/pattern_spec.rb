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
            expect( p ).to be_kind_of( Subordinate )
        end

        it 'should have a size' do
            p = Pattern.new
            expect( p.size ).to eq( 0 )
        end

        it 'should not have min and max methods' do
            p = Pattern.new
            expect { p.min }.to raise_error( NoMethodError )
            expect { p.max }.to raise_error( NoMethodError )
        end
    end
end

describe 'Group class' do
    context 'basic behaviour' do

        it 'should be creatable' do
            g = Group.new
        end

        it 'should be a kindof Subordinate' do
            g = Group.new
            expect( g ).to be_kind_of( Subordinate )
        end

        it 'should have default min and max repretitions of 1' do
            g = Group.new
            expect( g.min ).to eq( 1 )
            expect( g.max ).to eq( 1 )
        end

        it 'should have a size' do
            g = Group.new
            expect( g.size ).to eq( 0 )
        end
    end
end
