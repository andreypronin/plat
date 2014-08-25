require 'plat/env/config'
require 'plat/env/auth'

module Plat
  class Env
    def initialize
      yield configuration if block_given?
    end
  end
end