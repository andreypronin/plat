module Plat
  module Role
    class IAMRole
      extend Forwardable
      attr_reader :cpu_role
      def_delegators :@cpu_role, :layout, :options
      
      ACCESS_TYPES = [ :read, :write, :full ]

      def initialize(cpu_role)
        @cpu_role = cpu_role
      end
      
      def all_roles
        @all_roles ||= layout.roles.keys
      end
      
      def accessible_roles
        if access_options = options[:access]
          if (access_options.keys & ACCESS_TYPES).empty?
            roles_with_access access_options, :full
          else
            ACCESS_TYPES.map do |access_type|
              access_options[access_type] ? roles_with_access(access_options[access_type],access_type) : {}
            end.collect(&:+)
          end
        else
          roles_with_access all_roles, :full 
        end
      end
      def roles_with_access(access_options,access_type)
        roles = all_roles
        if access_options.is_a? Hash
          if access_options[:only]
            roles &= Array(access_options[:only])
          end
          if access_options[:except]
            roles -= Array(access_options[:except])
          end
        else
          roles &= Array(access_options)
        end
        roles.map { |role| [role,access_type] }.to_hash
      end

      def aws_policy
        @aws_policy ||= AWS::IAM::Policy.new do |policy|
          accessible_roles.each_pair do |role,access_type|
            role.allow_access(policy,access_type)
          end
        end
      end
    
    end
  end
end