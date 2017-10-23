require "cafe/view/controller"

module Cafe
  module Views
    class Welcome < Cafe::View::Controller
      configure do |config|
        config.template = "welcome"
      end
    end
  end
end
