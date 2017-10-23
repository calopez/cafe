module Test
  module WebHelpers
    module_function

    def app
      Cafe::Application.app
    end
  end
end
