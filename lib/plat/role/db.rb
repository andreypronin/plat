module Plat
  module Role
    class Db < Plat::Role::Basic
    end
  end
end

Plat::Role.register :db, Plat::Role::Db
  