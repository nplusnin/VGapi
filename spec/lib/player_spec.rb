require 'spec_helper'

describe VgApi::Player do
  describe "Player should return correct data" do
    let(:player) do
      file = File.read("spec/fixtures/player.json")
      VgApi::Player.new(JSON.parse(file)["data"][0])
    end

    it "should return name" do
      expect(player.name).to eq("NikitaPWNZ")
    end

    it "should return rank" do
      expect(player.rank).to eq(27)
    end

    it "should return wins count" do
      expect(player.wins).to eq(2652)
    end

    it "should return level" do
      expect(player.level).to eq(30)
    end
  end
end