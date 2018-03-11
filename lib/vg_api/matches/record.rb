module VgApi
  module Matches
    class Record
      attr_reader :data, :parent

      def initialize(data, parent)
        @data = data
        @parent = parent
      end

      def id
        data['id']
      end

      def find_included(type, id)
        parent.find_included(type, id)
      end

      def select_included(type, id)
        parent.select_included(type, id)
      end
    end
  end
end