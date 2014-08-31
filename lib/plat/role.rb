require 'yaml'

module Plat
  class Layout
    class Configuration
      def convert_roles(roles_def)
        case roles_def
          when Hash then roles_def
          when Array 
            roles_def.inject({}) do |result,elem|
              result.merge! convert_roles(elem)
            end
          when IO, StringIO, Tempfile then YAML.load(roles_def)
          when String, Pathname
            output = {}
            File.open(roles_def,"r") { |f| output = YAML.load(f) }
            output
          else
            raise ArgumentError.new("Wrong class for 'roles' value: #{roles_def.class}")
        end
      end
      param :roles, lockable: true, default: Hash.new, convert: :convert_roles
    end
  end
end

module Plat
  class Layout
    def roles
      @roles ||= begin
        configuration.roles.map do |role,options|
          [ role, Plat::Role.create(self,role,options) ]
        end.to_h
      end
    end
  end
end

module Plat
  module Role
    def self.registered_types
      @registered_types ||= {}
    end
    def self.register(type,cname)
      registered_types[type] = cname
    end

    def self.create(layout,role,options)
      if type = options[:type]
        raise ArgumentError.new "Wrong type for role #{@role}: #{options[:type]}" unless registered_types.member?(type)
      else
        rtype = role.downcase.to_sym
        type = registered_types.member?(rtype) ? rtype : :cpu
      end
      registered_types[type].new(layout,role,options)
    end
  end
end

require 'plat/role/basic' # require first to make available for the rest

require 'plat/role/cpu'
require 'plat/role/db'
require 'plat/role/cache'
require 'plat/role/files'
require 'plat/role/mail'
