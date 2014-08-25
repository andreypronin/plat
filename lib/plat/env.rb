require 'plat/env/config'
require 'plat/env/auth'
require 'plat/env/resource'

module Plat
  class Env
    def initialize(env)
      @env = String(env)
      yield self if block_given?
    end
    attr_reader :env
  end
end