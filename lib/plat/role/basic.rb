require 'aws-sdk'
require 'plat/role/iam_role'

module Plat
  module Role
    class Basic
      extend Forwardable
      attr_reader :layout, :role, :options
      def_delegators :@layout, :configuration
      def_delegators :configuration, :env
      
      def initialize(layout,role,options)
        @layout = layout
        @role = role
        @options = options.
                    merge(Hash(options[:default])).
                    merge(Hash(options["default"])).
                    merge(Hash(options[env.to_sym])).
                    merge(Hash(options[env.to_s]))
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

      def resource_name(id=0)
        layout.aws_resource_name(role,id)
      end

      def inspect
        "<#{self.class} role='#{self.role}'>"
      end
      def to_s
        { role => Hash(options) }.to_s
      end
      
      def allow_access(policy,access_type)
        # TODO
        # policy.allow
      end
    end
  end
end

