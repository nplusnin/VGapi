module VgApi
  class Roster < Record
    def win
      data['attributes']['won'] == "true" ? true : false
    end

    def side
      data['attributes']['stats']['side']
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

    def get_participants
      parent.find_included('participant', participant_ids).map do |participant|
        VgApi::Participant.new(participant, self)
      end
    end
  end
end