require "rack"
require "require_all"
require_all Dir.glob("**/**/*.rb").reject { |f| (f.start_with? "spec/")|| (f == "seeds.rb") }

app = Rack::Builder.new do
  use Rack::Reloader
  use RouteResolver
  use ParamsChecker
  run LicenseKeyEmailer::Rack.new
end.to_app

Rack::Handler::WEBrick.run(app)
