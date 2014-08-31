module Plat
  class Role
    class Cpu < Plat::Role::Basic
    end
  end
end

Plat::Role.register :cpu, Plat::Role::Cpu
  