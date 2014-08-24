module Plat
  class Env
    def initialize(env=nil)
      @blocks = env || [] # TODO: check & parse
    end
    
    include Enumerable
    def each
      @blocks.each
    end
  end
end

module Plat
  def env
    @env ||= Env.new
  end
  def env=(env)
    @env = Env.new(env)
  end
end