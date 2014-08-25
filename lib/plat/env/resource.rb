module Plat
  class Env
    class Resource
      def self.register id, klass
        types[id] = klass
      end
      def self.create(env,type,role,&block)
        raise ArgumentError unless klass = types[type.to_sym]
        klass.new(env,role,&block)
      end

      # private
      def self.types
        @types ||= {}
      end
      
      module Common
        def initialize(env,role)
          @env = env
          @role = role
          yield self if block_given?
        end
        
        def self.included(mod)
          if mod.const_defined? 'TYPE'
            type = mod.const_get 'TYPE'
          else
            type = mod.name.split('::')[-1].downcase.to_sym
          end
          Plat::Env::Resource.register type, mod
        end

        def count
          @count ||= 1
        end
        def count=(num)
          num = Integer(num)
          return ArgumentError if num <= 0
          @count = num
        end
      
        def name(id)
          return ArgumentError if id < 0 || id >= count
          @env.resource_name(@role,id)
        end

      end
    end
  end
end    

module Plat
  class Env
    def resource(role,type,&block)
      resources << Resource.create(self,type,role,&block)
    end

    private
    def resources
      @resources ||= []
    end
  end
end

require 'plat/env/resource/cpu'
require 'plat/env/resource/db'
require 'plat/env/resource/dns'
require 'plat/env/resource/file_store'
require 'plat/env/resource/kv_store'
require 'plat/env/resource/mail'
