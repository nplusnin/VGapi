module VgApi
  module Matches
    class Player < Record
      def name
        data['attributes']['name']
      end

      def to_h
        { name: name }
      end
    end
  end
end