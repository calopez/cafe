require "dry/web/container"

module Cafe
  class Container < Dry::Web::Container
    configure do
      config.name = :cafe
      config.listeners = true
      config.default_namespace = "cafe"
      config.auto_register = %w[lib/cafe]
    end

    load_paths! "lib"
  end
end
