module VgApi
  module Matches
    class Roster < Record
      def win?
        data['attributes']['won'] == "true" ? true : false
      end

      def side
        data['attributes']['stats']['side']
      end

      def gold
        data['attributes']['stats']['gold']
      end

      def aces
        data['attributes']['stats']['acesEarned']
      end

      def kills
        data['attributes']['stats']['heroKills']
      end

      def krakens
        data['attributes']['stats']['krakenCaptures']
      end

      def players
        @players ||= get_players
      end

      def participant_ids
        data["relationships"]["participants"]["data"].map do |p|
          p['id']
        end
      end

      def participants
        @participants ||= get_participants
      end

    private

      def get_players
        participants.map do |p|
          { hero: p.hero, name: p.player.name }
        end
      end

      def get_participants
        parent.find_included('participant', participant_ids).map do |participant|
          Participant.new(participant, self)
        end
      end
    end
  end
end