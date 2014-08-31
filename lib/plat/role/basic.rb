require 'aws-sdk'

module Plat
  class Role
    class Basic
      # Common implementation
      attr_reader :layout, :role, :options
      def initialize(layout,role,options)
        @layout = layout
        @role = role
        @options = options
      end
      def count
        @count ||= begin
          value = options.fetch(:count) { 1 }.to_i
          raise ArgumentError.new "Wrong count for role #{@role}: #{options[:count]}" if value < 1
          value
        end
      end
      def type
        Plat::Role.registered_types.find(->{[nil]}) { |elem| elem[1] == self.class }.first
      end
    end
  end
end

