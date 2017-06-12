require 'spec_helper'
require_relative '../../../lib/vg_api'

describe VgApi::Roster do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    matches = VgApi::Matches.new(JSON.parse(file))
    matches.matches.first
  end

  let(:roster) { match.rosters.first }

  it '.win' do
    expect(roster.win).to eq(true)
  end

  it 'should return correct data in first roster' do
    expect(roster.id).to eq("236f833d-4661-11e7-b1bb-0242ac11000b")
  end

  it 'should return correct participant_ids' do
    expected_participant_ids = [
      "236f603d-4661-11e7-b1bb-0242ac11000b", 
      "236f68f8-4661-11e7-b1bb-0242ac11000b", 
      "236f71a5-4661-11e7-b1bb-0242ac11000b"
    ]

    expect(roster.participant_ids).to eq(expected_participant_ids)
  end

  it '.side' do
    expect(roster.side).to eq("right/red")
  end

  it '.players' do
    expected_players = [
      {:hero=>"blackfeather", :name=>"NikitaPWNZ"}, 
      {:hero=>"ardan", :name=>"Nensons"}, 
      {:hero=>"skaarf", :name=>"c0cucka"}
    ]

    expect(roster.players).to eq(expected_players)
  end

  describe '.participants' do
    it 'should return array' do
      expect(roster.participants).to be_a(Array)
    end

    it 'should Participant object in array' do
      expect(roster.participants.first).to be_a(VgApi::Participant)
    end
  end
end