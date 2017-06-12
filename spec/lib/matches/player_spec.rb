require 'spec_helper'
require_relative '../../../lib/vg_api'

describe VgApi::Player do
  let(:match) do
    file = File.read("spec/fixtures/match.json")
    matches = VgApi::Matches.new(JSON.parse(file))
    matches.matches.first
  end

  let(:player) { match.rosters.first.participants.first.player }

  it '.name' do
    expect(player.name).to eq('NikitaPWNZ')
  end
end