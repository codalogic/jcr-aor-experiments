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

describe 'Instance class' do
    context 'basic behaviour' do
        instance = nil
        before do
            instance = Instance.new 'ab cd '
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

        it 'should have an each method' do
            res = ''
            instance.each { |i| res += i }
            expect( res ).to eq( 'abcd' )
        end
    end
end
