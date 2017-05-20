require 'spec_helper'

matches_json = File.open('spec/fixtures/matches.json').read
matches = JSON.parse(matches_json)

describe VgApi::Matches do
  describe 'should contain primary attributes like' do
    let(:match) { VgApi::Matches.new(matches['data'].first, matches['included']) }

    describe 'rosters' do
      it 'should return correct first roster' do
        expect(match.rosters.last['attributes']['won']).to eq('false')
      end

      it 'should return correct second roster' do
        expect(match.rosters.first['attributes']['won']).to eq('true')
      end
    end

    it 'participants'

    it 'players'

    it 'assets'
  end
end


