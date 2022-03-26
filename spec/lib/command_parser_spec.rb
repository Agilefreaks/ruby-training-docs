require 'spec_helper'
require './lib/command_parser'
require './lib/show_gem_command'

RSpec.describe CommandParser do
  describe '.parse' do
    let(:argv) { ['show', 'rspec'] }

    subject { CommandParser.parse(argv) }

    it 'returns a show command' do
      result = subject

      expect(result).to be_a(ShowGemCommand)
      expect(result.gem_name).to eq 'rspec'
    end
  end
end
