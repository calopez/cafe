require "dry/web/roda/application"
require_relative "container"

module Cafe
  class Application < Dry::Web::Roda::Application
    configure do |config|
      config.container = Container
      config.routes = "web/routes".freeze
    end

    opts[:root] = Pathname(__FILE__).join("../..").realpath.dirname

    plugin :rodauth, :json => :only do
      enable :jwt, :create_account, :login, :logout
      enable :session_expiration
      # enable :otp
      db Container['persistence.db']

      # ---------------------------
      # OTP
      # ---------------------------

      # ---------------------------
      # JWT Feature
      # ---------------------------

      jwt_secret Container['settings'].session_secret
      use_jwt? true

      # ---------------------------
      # Session Expiration Feature
      # ---------------------------
      session_expiration_default false
      session_inactivity_timeout 240

    end

    route do |r|
      r.multi_route

      r.root do
        'welcome :D'
      end
    end

    error do |e|
      self.class[:rack_monitor].instrument(:error, exception: e)
      raise e
    end

    load_routes!
  end
end
