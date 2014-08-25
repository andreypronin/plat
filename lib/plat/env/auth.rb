module Plat
  class Env
    def aws_auth
      {
        access_key_id: configuration.aws_access_key_id,
        secret_access_key: configuration.aws_secret_access_key
      }
    end
  end
end