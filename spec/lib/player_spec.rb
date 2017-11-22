require 'spec_helper'

describe VgApi::Player do
  describe ".find_by_name" do
    describe "request single player" do
      let(:data) { File.read("spec/fixtures/player.json") }

      before do
        allow(VgApi.client).to receive(:request).with(
          "shards/eu/players",
          "filter[playerNames]": "Player"
        ).and_return(JSON.parse(data))
      end

      it "should do request to api" do
        VgApi::Player.find_by_name("eu", "Player")
      end

      it "should return VgApi:Player instance class" do
        result = VgApi::Player.find_by_name("eu", "Player")

        expect(result).to be_a(VgApi::Player)
      end
    end

    describe "request few players" do
      let(:data) { File.read("spec/fixtures/players.json") }

      before do
        allow(VgApi.client).to receive(:request).with(
          "shards/eu/players",
          "filter[playerNames]": "Player1,Player2"
        ).and_return(JSON.parse(data))
      end

      it "if second argument is array" do
        VgApi::Player.find_by_name("eu", ["Player1", "Player2"])
      end

      it "if second argument is string" do
        VgApi::Player.find_by_name("eu", "Player1,Player2")
      end

      it "should return array" do
        result = VgApi::Player.find_by_name("eu", ["Player1", "Player2"])

        expect(result).to be_a(Array)
      end

      it "should return new player object in array" do
        result = VgApi::Player.find_by_name("eu", ["Player1", "Player2"])

        expect(result.first).to be_a(VgApi::Player)
      end
    end
  end


  describe "Player should return correct data" do
    let(:data) { File.read("spec/fixtures/player.json") }
    let(:player) { VgApi::Player.new(JSON.parse(data)["data"][0]) }

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