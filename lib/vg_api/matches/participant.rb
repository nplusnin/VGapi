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

      def stats_h
        { kills: kills, deaths: deaths, assists: assists, cs: cs }
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

      def kda
        ((kills.to_f + assists.to_f) / deaths.to_f).round(2)
      end

      def to_h
        { name: player.name, stats: stats_h, items: items }
      end

    private

      def get_player
        p = parent.find_included("player", player_id)
        Player.new(p, self)
      end
    end
  end
end