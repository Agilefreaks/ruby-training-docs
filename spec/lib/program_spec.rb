require 'spec_helper'
require './lib/program'

RSpec.describe Program do
  let(:argv) { [] }

  subject { Program.execute(argv) }

  describe 'show' do
    let(:argv) { ['show', 'rspec'] }

    it 'returns ShowResult' do
      result = subject

      expect(result.gem_name).to eq 'rspec'
      expect(result.description).to eq 'BDD for Ruby'
    end
  end
end
