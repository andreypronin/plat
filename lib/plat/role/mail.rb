module Plat
  module Role
    class Mail < Plat::Role::Basic
    end
  end
end

Plat::Role.register :mail, Plat::Role::Mail
  