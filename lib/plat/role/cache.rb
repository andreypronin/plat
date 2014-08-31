module Plat
  class Role
    class Cache < Plat::Role::Basic
    end
  end
end

Plat::Role.register :cache, Plat::Role::Cache
  