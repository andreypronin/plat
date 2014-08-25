require 'plat/env/config'

module Plat
  class Env
    def initialize
      yield configuration if block_given?
    end
  end
end