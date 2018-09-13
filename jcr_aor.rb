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

require_relative 'detail/pattern_tokeniser'
require_relative 'detail/pattern'
require_relative 'detail/instance'

$pattern = nil

def main
    Dir.glob( 'jcr_aor*.txt' ) { |fname| process_file fname }
end

def process_file fname
    line_num = 1
    File.foreach( fname ) { |line| process_line line_num, line; line_num += 1 }
end

def process_line line
    case line[0]
        when '?'
            parse_pattern line[1..-1]
        when '+'
            test_valid_instance line[1..-1]
        when '-'
            test_invalid_instance line[1..-1]
    end
end

def test_valid_instance line
    instance = Instance.new line
    puts instance[1]
    # TODO
end

def test_invalid_instance line
    # TODO
end

main if __FILE__ == $PROGRAM_NAME
