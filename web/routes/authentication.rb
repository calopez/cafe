require 'jwt'

module Cafe
  # doc
  class Application
    route 'auth' do |r|
      rodauth.check_session_expiration
      r.rodauth

      r.root do
        { json: 'awesome' }
      end

      r.on 'resource' do
        rodauth.require_authentication
        { secret: '87923md92kxosd' }
      end
    end
  end
end
