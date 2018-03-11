module VgApi
  module Matches
    class Roster < Record
      def win?
        data['attributes']['won'] == "true" ? true : false
      end

      def stats
        @stats ||= data['attributes']['stats']
      end

      def side
        stats['side']
      end

      def gold
        stats['gold']
      end

      def aces
        stats['acesEarned']
      end

      def kills
        stats['heroKills']
      end

      def krakens
        stats['krakenCaptures']
      end

      def players
        @players ||= get_players
      end

      def player?(player_name)
        players.each do |p|
          return true if p[:name] == player_name
        end

        false
      end

      def participant_ids
        data["relationships"]["participants"]["data"].map do |p|
          p['id']
        end
      end

      def participants
        @participants ||= get_participants
      end

      def allies(player_name)
        players.select do |p|
          p[:name] != player_name
        end
      end

      def to_h
        players_h = participants.map { |p| p.to_h }
        { win: win?, players: players_h }
      end

    private

      def get_players
        participants.map do |p|
          puts p.player.name
          { hero: p.hero, name: p.player.name }
        end
      end

      def get_participants
        parent.select_included('participant', participant_ids).map do |participant|
          Participant.new(participant, self)
        end
      end
    end
  end
end