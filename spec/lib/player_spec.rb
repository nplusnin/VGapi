require 'rspec'

require_relative '../../lib/vg_api'

player_json = File.open('spec/fixtures/player.json').read


describe VgApi::Player do
  context 'should contain primary attributes like' do
    let(:player) { VgApi::Player.new(player_json) }

    it 'id' do
      expect(player.id).to eq('04956f82-4b47-11e5-9536-06b48b82cd49')
    end

    it 'name' do
      expect(player.name).to eq('NikitaPWNZ')
    end

    it 'region' do
      expect(player.region).to eq('eu')
    end

    it 'level' do
      expect(player.level).to eq(30)
    end

    it 'win_streak' do
      expect(player.win_streak).to eq(0)
    end

    it 'loss_streak' do
      expect(player.loss_streak).to eq(0)
    end

    it 'skill_tier' do
      expect(player.skill_tier).to eq(27)
    end
  end
end