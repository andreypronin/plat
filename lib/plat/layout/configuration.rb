require 'configuru'

module Plat
  class Layout
    include Configuru::Configurable
    provide_configuration :instance
  end
end