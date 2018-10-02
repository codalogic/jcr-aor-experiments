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

    context 'simple validate function' do
        it 'should allow simple instance vs pattern validating' do
            expect( validation_of( 'a' ).against_pattern( 'a' ) ).to eq( true )
            expect( validation_of( 'b' ).against_pattern( 'a' ) ).to eq( false )
        end
    end

    context 'basic sequence validation' do
        it 'should say ab is valid for pattern ab' do
            expect( validation_of( 'ab' ).against_pattern( 'ab' ) ).to eq( true )
        end
        it 'should say abc (an extra token to be ignored) is valid for pattern ab' do
            expect( validation_of( 'abc' ).against_pattern( 'ab' ) ).to eq( true )
        end
        it 'should say b (missing a token) is not valid for pattern ab' do
            expect( validation_of( 'b' ).against_pattern( 'ab' ) ).to eq( false )
        end
    end

    context 'basic choice validation' do
        it 'should say b is valid for pattern a|b' do
            expect( validation_of( 'b' ).against_pattern( 'a|b' ) ).to eq( true )
        end
        it 'should say bc (an extra token to be ignored) is valid for pattern a|b' do
            expect( validation_of( 'bc' ).against_pattern( 'a|b' ) ).to eq( true )
        end
        it 'should say ab is not valid for pattern a|b' do
            expect( validation_of( 'ab' ).against_pattern( 'a|b' ) ).to eq( false )
        end
    end

    context 'basic group sequence validation' do
        it 'should say abcd is valid for pattern (ab)(cd)' do
            expect( validation_of( 'abcd' ).against_pattern( '(ab)(cd)' ) ).to eq( true )
        end
    end

    context 'basic group choice validation' do
        it 'should say ab is valid for pattern (ab)|(cd)' do
            expect( validation_of( 'ab' ).against_pattern( '(ab)|(cd)' ) ).to eq( true )
        end
        it 'should say abe (an extra token to be ignored) is valid for pattern (ab)|(cd)' do
            expect( validation_of( 'abe' ).against_pattern( '(ab)|(cd)' ) ).to eq( true )
        end
        it 'should say abc is not valid for pattern (ab)|(cd)' do
            expect( validation_of( 'abc' ).against_pattern( '(ab)|(cd)' ) ).to eq( false )
        end
        it 'should say e is not valid for pattern (ab)|(cd)' do
            expect( validation_of( 'e' ).against_pattern( '(ab)|(cd)' ) ).to eq( false )
        end
        it 'should say ef is valid for pattern (ab)|(cd)|(ef)' do
            expect( validation_of( 'ef' ).against_pattern( '(ab)|(cd)|(ef)' ) ).to eq( true )
        end
        it 'should say aef is not valid for pattern (ab)|(cd)|(ef)' do
            expect( validation_of( 'aef' ).against_pattern( '(ab)|(cd)|(ef)' ) ).to eq( false )
        end
    end

    context 'basic sequence with optional member validation' do
        it 'should say ab is valid for pattern ab?' do
            expect( validation_of( 'ab' ).against_pattern( 'ab?' ) ).to eq( true )
        end
        it 'should say a is valid for pattern ab?' do
            expect( validation_of( 'a' ).against_pattern( 'ab?' ) ).to eq( true )
        end
        it 'should say ab is valid for pattern ab?' do
            expect( validation_of( 'b' ).against_pattern( 'ab?' ) ).to eq( false )
        end
    end

    context 'basic choice with optional member validation' do
        it 'should say a is valid for pattern a|b?' do
            expect( validation_of( 'a' ).against_pattern( 'a|b?' ) ).to eq( true )
        end
        it 'should say b is valid for pattern a|b?' do
            expect( validation_of( 'b' ).against_pattern( 'a|b?' ) ).to eq( true )
        end
        it 'should say <empty> is valid for pattern a|b?' do
            expect( validation_of( '' ).against_pattern( 'a|b?' ) ).to eq( true )
        end
        it 'should say ab is not valid for pattern a|b?' do
            expect( validation_of( 'ab' ).against_pattern( 'a|b?' ) ).to eq( false )
        end
    end

    context 'choice group nested in choice validation' do
        it 'should say cd is valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'cd' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( true )
        end
        it 'should say ce is valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'ce' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( true )
        end
        it 'should say ced is not valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'ced' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( false )
        end
        it 'should say ace is not valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'ace' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( false )
        end
        it 'should say ab is valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'ab' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( true )
        end
        it 'should say abd is not valid for pattern (ab)|(c(d|e))' do
            expect( validation_of( 'abd' ).against_pattern( '(ab)|(c(d|e))' ) ).to eq( false )
        end
        it 'should say abd is valid for pattern (abd)|(c(d|e))' do
            expect( validation_of( 'abd' ).against_pattern( '(abd)|(c(d|e))' ) ).to eq( true )
        end
    end

    context 'optional groups' do
        it 'should say abc is valid for pattern a(bc)?' do
            expect( validation_of( 'abc' ).against_pattern( 'a(bc)?' ) ).to eq( true )
        end
        it 'should say a is valid for pattern a(bc)?' do
            expect( validation_of( 'a' ).against_pattern( 'a(bc)?' ) ).to eq( true )
        end
        it 'should say ab is not valid for pattern a(bc)?' do
            expect( validation_of( 'ab' ).against_pattern( 'a(bc)?' ) ).to eq( false )
        end
    end

    context 'optional groups with optional members' do
        it 'should say <empty> is valid for pattern (ab?)?' do
            expect( validation_of( '' ).against_pattern( '(ab?)?' ) ).to eq( true )
        end
        it 'should say a is valid for pattern (ab?)?' do
            expect( validation_of( 'a' ).against_pattern( '(ab?)?' ) ).to eq( true )
        end
        it 'should say ab is valid for pattern (ab?)?' do
            expect( validation_of( 'ab' ).against_pattern( '(ab?)?' ) ).to eq( true )
        end
        it 'should say b is not valid for pattern (ab?)?' do
            expect( validation_of( 'b' ).against_pattern( '(ab?)?' ) ).to eq( false )
        end
    end

    context 'multiple instance members' do
        it 'should say aa is valid for pattern a2' do
            expect( validation_of( 'aa' ).against_pattern( 'a2' ) ).to eq( true )
        end
        it 'should say aaa is not valid for pattern a2' do
            expect( validation_of( 'aaa' ).against_pattern( 'a2' ) ).to eq( false )
        end
    end

    context 'from JCR validator tests' do
        it 'should pass object with complex nested groups 1' do
            expect( validation_of( 'abd' ).against_pattern( '((ab)|c)d' ) ).to eq( true )
        end
    
        it 'should pass object with complex nested groups 2' do
            expect( validation_of( 'cd' ).against_pattern( '((ab)|c)d' ) ).to eq( true )
        end
    
        it 'should fail object with complex nested groups 1' do
            expect( validation_of( 'zd' ).against_pattern( '((ab)|c)d' ) ).to eq( false )
        end
    end
end
