require 'plat/layout/configuration'
require 'plat/layout/aws'

module Plat
  class Layout
    def initialize(options={},&block)
      configure(options,&block)
      configuration.lock
    end
  end
end