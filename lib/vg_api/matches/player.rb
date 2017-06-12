module VgApi
  class Player < Record
    def name
      data['attributes']['name']
    end
  end
end