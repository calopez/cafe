begin
  require "pry-byebug"
rescue LoadError
end

require_relative "cafe/container"

Cafe::Container.finalize!

require "cafe/application"
