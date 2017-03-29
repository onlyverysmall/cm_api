require "rack"
require "require_all"
require_all "app"

app = Rack::Builder.new do
  use Rack::Reloader
  use RouteResolver
  use ParamsChecker
  run LicenseKeyEmailer::Rack.new
end.to_app

Rack::Handler::WEBrick.run(app)
