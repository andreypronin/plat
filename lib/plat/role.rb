module Plat
  class Role
    def self.registered_types
      @registered_types ||= {}
    end
    def self.register(type,cname)
      registered_types[type] = cname
    end

    def self.create(layout,role,options)
      if type = options[:type]
        raise ArgumentError.new "Wrong type for role #{@role}: #{options[:type]}" unless registered_types.keys.include?(type)
      else
        type = registered_types.keys.include?(role.to_sym) ? role.to_sym : :cpu
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
