require 'spec_helper'

describe VgApi::Matches::Roster do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    matches = VgApi::Matches::Collection.new(JSON.parse(file))
    matches.matches.first
  end

  let(:roster) { match.rosters.first }

  it '.win?' do
    expect(roster.win?).to eq(true)
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

  it '.gold' do
    expect(roster.gold).to eq(56365)
  end

  it '.krakens' do
    expect(roster.krakens).to eq(1)
  end

  it '.aces' do
    expect(roster.aces).to eq(3)
  end

  it '.kills' do
    expect(roster.kills).to eq(17)
  end

  it '.players' do
    expected_players = [
      {:hero=>"blackfeather", :name=>"NikitaPWNZ"}, 
      {:hero=>"ardan", :name=>"Nensons"}, 
      {:hero=>"skaarf", :name=>"c0cucka"}
    ]

    expect(roster.players).to eq(expected_players)
  end

  it '.allies' do
    expected_allies = [{:hero=>"ardan", :name=>"Nensons"}, {:hero=>"skaarf", :name=>"c0cucka"}]
    expect(roster.allies('NikitaPWNZ')).to eq(expected_allies)
  end

  describe '.player?' do
    it 'should return true if player name exist in roster' do
      roster.player?("NikitaPWNZ")
    end

    it 'should return false if player name not exist in roster' do
      roster.player?("UnknowPlayer")
    end
  end

  describe '.participants' do
    it 'should return array' do
      expect(roster.participants).to be_a(Array)
    end

    it 'should Participant object in array' do
      expect(roster.participants.first).to be_a(VgApi::Matches::Participant)
    end
  end
end