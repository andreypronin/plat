require 'gem_config'

module Plat
  class Env
    include GemConfig::Base

    with_configuration do
      # TODO
      # has :api_key, classes: String
      # has :format, values: [:json, :xml], default: :json
      # has :region, values: ['us-west', 'us-east', 'eu'], default: 'us-west'
    end
  end
end