module VgApi
  module Matches
    class Player < Record
      def name
        data['attributes']['name']
      end
    end
  end
end