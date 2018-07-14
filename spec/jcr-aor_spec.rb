# Copyright (c) 2018, Codalogic Ltd (http://www.codalogic.com)
# MIT Licensed

require 'spec_helper'
require 'rspec'
require_relative '../jcr-aor'

describe 'instance behaviour' do
    it 'should One eq 1' do
        puts "A test"
        expect( One() ).to eq( 1 )
    end
end
