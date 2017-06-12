require 'spec_helper'
require_relative '../../../lib/vg_api'

describe VgApi::Match do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    matches = VgApi::Matches.new(JSON.parse(file))
    matches.matches.first
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

  it '.right_side' do
    expect(match.right_side).to eq(match.rosters.first)
  end

  it '.left_side' do
    expect(match.left_side).to eq(match.rosters.last)
  end

  it '.winners_team' do
    expect(match.winners_team).to eq(match.rosters.first)
  end

  describe '.player_win?' do
    it 'should return true if player win match' do
      expect(match.player_win?("NikitaPWNZ")).to eq(true)
    end

    it 'should return false if player loose match' do
      expect(match.player_win?("KRATOS2S")).to eq(false)
    end
  end

  describe '.rosters' do
    it 'should return array' do
      expect(match.rosters).to be_a(Array)
    end

    it 'should return roster object in array' do
      expect(match.rosters.first).to be_a(VgApi::Roster)
    end
  end
end
