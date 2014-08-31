module Plat
  module Role
    class Files < Plat::Role::Basic
    end
  end
end

Plat::Role.register :files, Plat::Role::Files
  