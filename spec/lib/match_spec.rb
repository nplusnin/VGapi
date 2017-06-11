require 'spec_helper'
require_relative '../../lib/vg_api'

describe Match do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    data = JSON.parse(file.to_s) 
    Match.new(data["data"].first, data["included"])
  end

  it '.id' do
    expect(match.id).to eq("77450c56-465c-11e7-967c-02fd63b150ad")
  end

  it '.game_mode' do
    expect(match.game_mode).to eq("ranked")
  end

  it '.duration' do
    expect(match.duration).to eq(1804)
  end

  it '.rosters_ids' do
    expected_rosters = ["236f600a-4661-11e7-b1bb-0242ac11000b", "236f833d-4661-11e7-b1bb-0242ac11000b"]
    expect(match.rosters_ids).to eq(expected_rosters)
  end

  describe '.rosters' do
    it 'should return array' do
      expect(match.rosters).to be_a(Array)
    end

    it 'should return roster object in array' do
      expect(match.rosters.first).to be_a(Roster)
    end
  end

  describe Roster do
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

    describe '.participants' do
      it 'should return array' do
        expect(roster.participants).to be_a(Array)
      end

      it 'should Participant object in array' do
        expect(roster.participants.first).to be_a(Participant)
      end
    end

    describe Participant do
      let(:participant) { roster.participants.first }

      it '.id' do
        expect(participant.id).to eq("236f603d-4661-11e7-b1bb-0242ac11000b")
      end

      it '.hero' do
        expect(participant.hero).to eq('blackfeather')
      end

      it '.player_id' do
        expect(participant.player_id).to eq("04956f82-4b47-11e5-9536-06b48b82cd49")
      end

      describe '.items' do
        it 'should return array' do
          expect(participant.items).to be_a(Array)
        end

        it 'should return correct data' do
          items = ["Slumbering Husk", "Serpent Mask", "Breaking Point", "War Treads", "Aegis", "Atlas Pauldron"]

          expect(participant.items).to eq(items)
        end
      end

      describe '.players' do
        it 'should return player object' do
          expect(participant.player).to be_a(Player)
        end
      end

      describe Player do
        let(:player) { participant.player }

        it '.name' do
          expect(player.name).to eq('NikitaPWNZ')
        end
      end
    end
  end
end
