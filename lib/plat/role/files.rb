module Plat
  class Role
    class Files < Plat::Role::Basic
    end
  end
end

Plat::Role.register :files, Plat::Role::Files
  