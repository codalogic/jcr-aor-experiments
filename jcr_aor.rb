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

require_relative 'detail/pattern'
require_relative 'detail/validator'

$pattern = nil

def main
    if ARGV.size == 2
        test_command_line_pattern ARGV[0], ARGV[1]
    else
        Dir.glob( 'jcr_aor*.txt' ) { |fname| process_file fname }
    end
end

def test_command_line_pattern instance, pattern_string
    begin
        pattern = Pattern.new pattern_string
    rescue StandardError => e
        puts "Error parsing pattern: #{e.message}"
        return
    end
    result = Validator.new( pattern ).valid?( instance )
    puts "Instance: #{instance}, Pattern: #{pattern_string}\n#{result ? 'valid' : 'invalid'}"
end

def process_file fname
    line_num = 1
    File.foreach( fname ) { |line| process_line line_num, line; line_num += 1 }
end

def process_line line_num, line
    line.strip!
    case line[0]
        when '?'
            puts "        #{line[1..-1]} pattern on line: #{line_num}"
            puts "        -------------------------------------------"
            parse_pattern line_num, line[1..-1]
        when '+'
            test_valid_instance line[1..-1]
        when '-'
            test_invalid_instance line[1..-1]
    end
end

def test_valid_instance line
    puts status_indicator( test_instance( line ) ) + line + " - expected valid"
end

def test_invalid_instance line
    puts status_indicator( ! test_instance( line ) ) + line + " - expected invalid"
end

def test_instance line
    if not $pattern.nil?
        return Validator.new( $pattern ).valid?( line )
    else
        puts "not ok: No pattern for #{line}"
        return false
    end
end

def status_indicator result
    result ? "    ok: " : "not ok: "
end

main if __FILE__ == $PROGRAM_NAME
