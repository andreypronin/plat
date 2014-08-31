require 'plat/layout/configuration'
require 'plat/layout/aws'

module Plat
  class Layout
    def initialize(options={},&block)
      configure(options,&block)
      configuration.lock
    end
    
    def inspect
      "<#{self.class} #{configuration.to_s}>"
    end
  end
end