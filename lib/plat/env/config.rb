require 'gem_config'

module Plat
  class Env
    include GemConfig::Base
    
    AWS_KEYS = %w(aws_access_key_id aws_secret_access_key)
    STR_KEYS = %w(name_prefix app_name) + AWS_KEYS

    with_configuration do
      AWS_KEYS.each do |var|
        has var.to_sym, classes: String, default: (ENV[var.upcase] || '???')
      end
      has :name_prefix, classes: String, default: ''
      has :app_name, classes: String, default: 'myapp'
    end
    
    STR_KEYS.each do |var|
      attr_reader var.to_sym
      define_method("#{var}=") do |str|
        instance_variable_set "@#{var}", String(str)
      end
      define_method("#{var}") do
        unless instance_variable_defined? "@#{var}"
          instance_variable_set "@#{var}", Plat::Env.configuration.send(var)
        end
        instance_variable_get "@#{var}"
      end
    end
    
  end
end