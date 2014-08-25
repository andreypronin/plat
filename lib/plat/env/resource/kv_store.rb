module Plat
  class Env
    class Resource
      class KVStore
        TYPE = :kvstore
        include Plat::Env::Resource::Common
      end
    end
  end
end
