module Plat
  module Role
    class Cache < Plat::Role::Basic
    end
  end
end

Plat::Role.register :cache, Plat::Role::Cache
  