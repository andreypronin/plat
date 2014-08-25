module Plat
  class Env
    class Resource
      class DB
        TYPE = :db
        include Plat::Env::Resource::Common
      end
    end
  end
end
