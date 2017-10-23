Cafe::Container.finalize :settings do |container|
  init do
    require "cafe/settings"
  end

  start do
    settings = Cafe::Settings.load(container.config.root, container.config.env)
    container.register "settings", settings
  end
end
