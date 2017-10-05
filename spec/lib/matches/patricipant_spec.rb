require 'spec_helper'

describe VgApi::Matches::Participant do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    matches = VgApi::Matches::Collection.new(JSON.parse(file))
    matches.matches.first
  end

  let(:participant) { match.rosters.first.participants.first }

  it '.id' do
    expect(participant.id).to eq("236f603d-4661-11e7-b1bb-0242ac11000b")
  end

  it '.hero' do
    expect(participant.hero).to eq('blackfeather')
  end

  it '.player_id' do
    expect(participant.player_id).to eq("04956f82-4b47-11e5-9536-06b48b82cd49")
  end

  it '.krakens' do
    expect(participant.krakens).to eq(0)
  end

  describe '.items' do
    it 'should return array' do
      expect(participant.items).to be_a(Array)
    end

    it 'should return correct data' do
      items = ["slumbering-husk", "serpent-mask", "breaking-point", "war-treads", "aegis", "atlas-pauldron"]

      expect(participant.items).to eq(items)
    end
  end

  describe '.players' do
    it 'should return player object' do
      expect(participant.player).to be_a(VgApi::Matches::Player)
    end
  end
end