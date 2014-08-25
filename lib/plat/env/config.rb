require 'gem_config'

module Plat
  class Env
    include GemConfig::Base
    
    AWS_KEYS = %w(aws_access_key_id aws_secret_access_key)

    with_configuration do
      AWS_KEYS.each do |var|
        has var.to_sym, classes: String, default: ENV[var.upcase]
      end
    end

    class Configuration
      def initialize
        AWS_KEYS.each do |var|
          self.instance_variable_set "@#{var}", Plat::Env.configuration.send(var)
        end
      end
      
      AWS_KEYS.each do |var|
        attr_reader var.to_sym
        define_method("#{var}=") do |str|
          self.instance_variable_set "@#{var}", String(str)
        end
      end
    end
    
    def configuration
      @configuration ||= Configuration.new
    end
    def configure
      yield configuration if block_given?
    end
  end
end