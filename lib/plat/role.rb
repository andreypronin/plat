module Plat
  class Role
    def initialize(layout,role,options)
      @layout = layout
      @role = role
      @options = options
    end
    def type
      @type ||= begin
        value = options.fetch(:type) { type_from_role }
        raise ArgumentError.new "Wrong type for role #{@role}: #{options[:type]}" unless TYPES.include?(value)
        value
      end
    end
    def count
      @count ||= begin
        value = options.fetch(:count) { 1 }.to_i
        raise ArgumentError.new "Wrong count for role #{@role}: #{options[:count]}" if value < 1
        value
      end
    end
    
    private
    def type_from_role
      return role.to_sym if TYPES.include? role.to_sym
      :ec2
    end
  end
end