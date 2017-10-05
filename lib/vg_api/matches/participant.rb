module VgApi
  module Matches
    class Participant < Record
      def hero
        data['attributes']['actor'].gsub('*', '').downcase
      end

      def items
        @items ||= stats['items'].map do |item|
          item.gsub(' ', '-').downcase
        end
      end

      def player_id
        data["relationships"]["player"]["data"]["id"]
      end

      def player
        player ||= get_player
      end

      def stats
        data['attributes']['stats']
      end

      def kills
        stats['kills']
      end

      def deaths
        stats['deaths']
      end

      def assists
        stats['assists']
      end

      def cs
        stats['minionKills']
      end

      def krakens
        stats['krakenCaptures']
      end

      def skin
        data['attributes']['skinKey']
      end

    private

      def get_player
        parent.find_included("player", player_id).map do |player|
          Player.new(player, self)
        end.first
      end
    end
  end
end