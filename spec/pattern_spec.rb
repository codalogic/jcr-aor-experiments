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

        it 'should not have rep= method' do
            p = Pattern.new
            expect { p.rep = PatternTokeniser::Rep.new '?' }.to raise_error( NoMethodError )
        end
    end

    context 'composition behaviour' do
        it 'should allow a Member object to be added to it' do
            p = Pattern.new
            p << Member.new( 'a' )
            expect( p.size ).to eq( 1 )
        end

        it 'should allow a Group object to be added to it' do
            p = Pattern.new
            p << Group.new
            expect( p.size ).to eq( 1 )
        end

        it 'should allow accessing members via an index' do
            p = Pattern.new
            p << Member.new( 'a' )
            expect( p[0] ).to be_instance_of( Member )
        end

        it 'should be iterable via an each method with 1 member' do
            p = Pattern.new
            p << Member.new( 'a' )
            has_member = false
            count = 0
            p.each { |m| has_member = true if m.instance_of? Member; count += 1 }
            expect( has_member ).to be( true )
            expect( count ).to be( 1 )
        end

        it 'should be iterable via an each method with two members' do
            p = Pattern.new
            p << Member.new( 'a' )
            p << Group.new
            has_member = false
            count = 0
            p.each { |m| has_member = true if m.instance_of? Member; count += 1 }
            expect( has_member ).to be( true )
            expect( count ).to be( 2 )
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

    context 'composition behaviour' do
        it 'should allow a Member object to be added to it' do
            g = Group.new
            g << Member.new( 'a' )
            expect( g.size ).to eq( 1 )
        end

        it 'should allow a Group object to be added to it' do
            g = Group.new
            g << Group.new
            expect( g.size ).to eq( 1 )
        end

        it 'should allow accessing members via an index' do
            g = Group.new
            g << Member.new( 'a' )
            expect( g[0] ).to be_instance_of( Member )
        end

        it 'should be iterable via an each method with 1 member' do
            g = Group.new
            g << Member.new( 'a' )
            has_member = false
            count = 0
            g.each { |m| has_member = true if m.instance_of? Member; count += 1 }
            expect( has_member ).to be( true )
            expect( count ).to be( 1 )
        end

        it 'should be iterable via an each method with two members' do
            g = Group.new
            g << Member.new( 'a' )
            g << Group.new
            has_member = false
            count = 0
            g.each { |m| has_member = true if m.instance_of? Member; count += 1 }
            expect( has_member ).to be( true )
            expect( count ).to be( 2 )
        end
    end
end

describe 'Member class' do
    context 'basic behaviour' do

        it 'should be creatable' do
            m = Member.new 'a'
        end

        it 'should be a kindof Subordinate' do
            m = Member.new 'a'
            expect( m ).to be_kind_of( Subordinate )
        end

        it 'should have default min and max repretitions of 1' do
            m = Member.new 'a'
            expect( m.min ).to eq( 1 )
            expect( m.max ).to eq( 1 )
        end

        it 'should have a c method that returns a stored character' do
            m = Member.new 'a'
            expect( m.c ).to eq( 'a' )
        end

    end
end
