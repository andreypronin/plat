require 'aws-sdk'

module Plat
  class Role
    class Basic
      # Common implementation
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
    end
  end
end

