require 'plat/env/config'

module Plat
  class Env
    def initialize(env=nil)
      @blocks = env || {} # TODO: check & parse
    end
    
    include Enumerable
    def each
      @blocks.each
    end
  end
end