module Plat
  class Layout
    %w(aws_access_key_id aws_secret_access_key).each do |name|
      def_config_param name, make_string: true, lockable: true, not_empty: true, default: (ENV[name.upcase] || '???')
    end
    def_config_param :env, make_string: true, lockable: true, not_empty: true, default: '' # production, development, test, ...
    def_config_param :name_prefix, make_string: true, lockable: true, default: ''
    def_config_param :app_name, make_string: true, lockable: true, default: ''
  end
end

module Plat
  class Layout
    def aws_options
      @aws_options ||= 
      {
        access_key_id: configuration.aws_access_key_id,
        secret_access_key: configuration.aws_secret_access_key
      }
    end
    
    def aws_role_name_prefix(role)
      @aws_role_name_prefix ||= {}
      @aws_role_name_prefix[role] ||= 
        [ configuration.name_prefix, 
          configuration.app_name, 
          configuration.env, 
          role ].map(&:to_s).delete_if{|s| s==''}.join('-').gsub(/\s/,'_')
    end
    def aws_resource_name(role,id=0)
      aws_role_name_prefix(role)+'-'+id.to_s
    end
  end
end