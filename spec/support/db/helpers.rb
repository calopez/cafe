module Test
  module DatabaseHelpers
    module_function

    def rom
      Cafe::Container["persistence.rom"]
    end

    def db
      Cafe::Container["persistence.db"]
    end
  end
end
