module Plat
  class Env
    class Resource
      class Mail 
        TYPE = :mail
        include Plat::Env::Resource::Common
      end
    end
  end
end