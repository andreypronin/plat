require 'yaml'

module Plat
  class Layout
    class Configuration
      def initialize
        @locked = false
      end
      def lock(flag=true)
        @locked = flag
      end
      def is_locked
        @locked
      end
      
      def configure(options={})
        Hash(options).each_pair do |name,value|
          if name == :options_source
            if value.is_a? IO
              sub_options = YAML.load value
            else
              File.open( value, "r" ) { |f| sub_options = YAML.load(f) }
            end
            apply(sub_options)
          else
            send("#{name.to_s}=",value)
          end
        end
        yield self if block_given?
        self
      end
      
      def self.param(name,options={})
        inst_var = "@#{name.to_s}"
        define_method(name) do
          if !instance_variable_defined?(inst_var) && options.has_key?(:default)
            instance_variable_set inst_var, options[:default]
          end
          instance_variable_get inst_var
        end

        define_method("#{name.to_s}=") do |value|
          if options[:lockable] && is_locked
            raise ArgumentError.new("'#{name.to_s}' cannot be set at this time")
          end
          if options[:not_nil] && value.nil?
            raise ArgumentError.new("'#{name.to_s}' cannot be nil")
          end
          if options[:not_empty] && (value.nil? || value.empty?)
            raise ArgumentError.new("'#{name.to_s}' cannot be empty")
          end
          if options.has_key?(:must_be) && !Array(options[:must_be]).include?(value.class)
            valid_class = false
            Array(options[:must_be]).each do |cname|
              valid_class = true if value.is_a?(cname)
            end
            raise ArgumentError.new("Wrong class (#{value.class}) for '#{name.to_s}' value") unless valid_class
          end
          if options.has_key?(:must_respond_to)
            Array(options[:must_respond_to]).each do |mname|
              raise ArgumentError.new("'#{name.to_s}' must respond to '#{mname}'") unless value.respond_to?(mname)
            end
          end
          value = Hash(value) if options[:make_hash]
          value = Array(value) if options[:make_array]
          value = String(value) if options[:make_string]
          value = value.to_i if options[:make_int]
          value = value.to_f if options[:make_float]
          value = !!value if options[:make_bool]
          if options.has_key?(:max) && (value > options[:max])
            raise ArgumentError.new("'#{name.to_s}' must no be more than #{options[:max]}")
          end
          if options.has_key?(:min) && (value < options[:min])
            raise ArgumentError.new("'#{name.to_s}' must no be less than #{options[:min]}")
          end
          if options.has_key?(:in) && !options[:in].include?(value)
            raise ArgumentError.new("'#{name.to_s}' is out of range")
          end
          if options.has_key?(:convert)
            if options[:convert].is_a? Symbol
              value = send options[:convert], value
            else
              value = options[:convert].call( value )
            end
          end

          instance_variable_set inst_var, value
        end
        name
      end
    end
  end
end

module Plat
  class Layout
    def configuration
      @configuration ||= Plat::Layout::Configuration.new
    end
    def configure(options={},&block)
      configuration.configure(options,&block)
    end
  end
end