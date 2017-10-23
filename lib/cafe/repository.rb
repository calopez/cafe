require "rom-repository"
require "cafe/container"
require "cafe/import"

Cafe::Container.boot! :rom

module Cafe
  class Repository < ROM::Repository::Root
    include Cafe::Import.args["persistence.rom"]
  end
end
