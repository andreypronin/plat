module Plat
  class Env
    def aws_auth
      {
        access_key_id: aws_access_key_id,
        secret_access_key: aws_secret_access_key
      }
    end
    def resource_name(role,id=1)
      "#{resource_name_prefix}-#{String(role)}-#{String(id)}".gsub(' ','_')
    end

    private 
    def resource_name_prefix
      "#{name_prefix}#{app_name}-#{env}"
    end
  end
end