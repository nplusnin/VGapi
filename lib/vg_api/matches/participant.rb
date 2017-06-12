module VgApi
  class Participant < Record
    def hero
      data['attributes']['actor'].gsub('*', '').downcase
    end

    def items
      data['attributes']['stats']['items']
    end

    def player_id
      data["relationships"]["player"]["data"]["id"]
    end

    def player
      player ||= get_player
    end

    # Протестировать

    def player_name
      player.name
    end

    def stats
      {
        kills: data['attributes']['stats']['kills'],
        deaths: data['attributes']['stats']['deaths'],
        assists: data['attributes']['stats']['assists'],
        cs: data['attributes']['stats']['minionKills']
      }
    end

    def skin
      data['attributes']['skinKey']
    end

  private

    def get_player
      parent.find_included("player", player_id).map do |player|
        VgApi::Player.new(player, self)
      end.first
    end
  end

end