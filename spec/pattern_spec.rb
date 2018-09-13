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

        it 'should indicate whether it is a sequence' do
            p = Pattern.new
            expect( p.sequence? ).to eq( true )
            expect( p.choice? ).to eq( false )
        end

        it 'should be settable to a choice and indicate whether it is a choice' do
            p = Pattern.new
            p.choice
            expect( p.choice? ).to eq( true )
            expect( p.sequence? ).to eq( false )
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

        it 'should have default min and max repetitions of 1' do
            g = Group.new
            expect( g.min ).to eq( 1 )
            expect( g.max ).to eq( 1 )
        end

        it 'should have be able to set min and max repetitions via a Rep object' do
            g = Group.new
            g.rep = PatternTokeniser::Rep.new '*'
            expect( g.min ).to eq( 0 )
            expect( g.max ).to eq( nil )
        end

        it 'should indicate whether it is a sequence' do
            g = Group.new
            expect( g.sequence? ).to eq( true )
            expect( g.choice? ).to eq( false )
        end

        it 'should be settable to a choice and indicate whether it is a choice' do
            g = Group.new
            g.choice
            expect( g.choice? ).to eq( true )
            expect( g.sequence? ).to eq( false )
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

        it 'should have be able to set min and max repetitions via a Rep object' do
            m = Member.new 'a'
            m.rep = PatternTokeniser::Rep.new '*'
            expect( m.min ).to eq( 0 )
            expect( m.max ).to eq( nil )
        end

        it 'should have a c method that returns a stored character' do
            m = Member.new 'a'
            expect( m.c ).to eq( 'a' )
        end

        it 'should have a matches? method that returns true if the given character matches the stored character' do
            m = Member.new 'a'
            expect( m.matches?( 'a' ) ).to be( true )
        end

        it 'should have a matches? method that returns false if the given character does not matche the stored character' do
            m = Member.new 'a'
            expect( m.matches?( 'b' ) ).to be( false )
        end

        it 'should have a matches? method that returns true for all given characters when matching the wildcard' do
            m = Member.new '.'
            expect( m.matches?( 'a' ) ).to be( true )
            expect( m.matches?( 'b' ) ).to be( true )
        end

    end
end

describe 'parse_pattern global method' do
    context 'basic behaviour' do

        it 'should be created when parse_pattern method called' do
            parse_pattern 1, "abc"
            expect( $pattern ).to be_instance_of( Pattern )
        end

        it 'should return the size of a single character base pattern' do
            parse_pattern 1, "a"
            expect( $pattern.size ).to eq( 1 )
        end

        it 'should return the size of multiple character base pattern' do
            parse_pattern 1, "abc"
            expect( $pattern.size ).to eq( 3 )
        end

        it 'should return the size of multiple character base pattern with spaces in it' do
            parse_pattern 1, "a b c"
            expect( $pattern.size ).to eq( 3 )
        end

        it 'should be able to access the characters in a pattern' do
            parse_pattern 1, "abc"
            expect( $pattern[0].c ).to eq( 'a' )
            expect( $pattern[1].c ).to eq( 'b' )
            expect( $pattern[2].c ).to eq( 'c' )
        end

        it 'should parse a repetition of ?' do
            parse_pattern 1, "a?"
            expect( $pattern[0].min ).to eq( 0 )
            expect( $pattern[0].max ).to eq( 1 )
        end

        it 'should parse a repetition of *' do
            parse_pattern 1, "a*"
            expect( $pattern[0].min ).to eq( 0 )
            expect( $pattern[0].max ).to eq( nil )
        end

        it 'should parse a repetition of +' do
            parse_pattern 1, "a+"
            expect( $pattern[0].min ).to eq( 1 )
            expect( $pattern[0].max ).to eq( nil )
        end

        it 'should parse a repetition of + followed by a repetition of 6' do
            parse_pattern 1, "a+b6"
            expect( $pattern[0].min ).to eq( 1 )
            expect( $pattern[0].max ).to eq( nil )
            expect( $pattern[1].min ).to eq( 6 )
            expect( $pattern[1].max ).to eq( 6 )
        end

        it 'should parse a repetition of + followed by a repetition of 6~' do
            parse_pattern 1, "a+b6~c"
            expect( $pattern[0].min ).to eq( 1 )
            expect( $pattern[0].max ).to eq( nil )
            expect( $pattern[1].min ).to eq( 6 )
            expect( $pattern[1].max ).to eq( nil )
        end

        it 'should parse a repetition of + followed by a repetition of 6~100' do
            parse_pattern 1, "a+b6~100c"
            expect( $pattern[0].min ).to eq( 1 )
            expect( $pattern[0].max ).to eq( nil )
            expect( $pattern[1].min ).to eq( 6 )
            expect( $pattern[1].max ).to eq( 100 )
        end

        it 'should be a sequence be default' do
            parse_pattern 1, "a"
            expect( $pattern.sequence? ).to eq( true )
            expect( $pattern.choice? ).to eq( false )
        end

        it 'should be settable to a choice' do
            parse_pattern 1, "a|"
            expect( $pattern.sequence? ).to eq( false )
            expect( $pattern.choice? ).to eq( true )
        end
    end

    context 'nested group behaviour' do

        it 'should be able to add a nested group' do
            parse_pattern 1, "a(b)c"
            expect( $pattern[0].c ).to eq( 'a' )
            expect( $pattern[1] ).to be_instance_of( Group )
            expect( $pattern[1][0].c ).to eq( 'b' )
            expect( $pattern[2].c ).to eq( 'c' )
        end

        it 'should be able to add a nested choice group' do
            parse_pattern 1, "a(b|)c"
            expect( $pattern[0].c ).to eq( 'a' )
            expect( $pattern[1] ).to be_instance_of( Group )
            expect( $pattern[1].choice? ).to be( true )
            expect( $pattern[1][0].c ).to eq( 'b' )
            expect( $pattern[2].c ).to eq( 'c' )
        end
    end

    context 'error handling' do

        it 'should raise an error if the end of the pattern is found while nested' do
            expect { parse_pattern_with_exceptions "a(b" }.to raise_error( RuntimeError )
        end

        it 'should raise an error if the pattern contains illegal characters' do
            expect { parse_pattern_with_exceptions "a%b" }.to raise_error( RuntimeError )
        end

        it 'should raise an error if unmatched closing brackets' do
            expect { parse_pattern_with_exceptions "a(b)c)d" }.to raise_error( RuntimeError )
        end
    end
end
