require 'spec_helper'

describe Plat::Layout do
  it 'can be configured (smoke test)' do
    layout = Plat::Layout.new(env: :my_special_env) do |cfg|
      cfg.app_name = 'someAwesomeApp'
    end
    expect(layout.configuration.env).to eq 'my_special_env'
    expect(layout.configuration.app_name).to eq 'someAwesomeApp'
  end
end