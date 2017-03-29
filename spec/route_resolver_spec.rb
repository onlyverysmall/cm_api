require_all Dir.glob("**/**/*.rb").reject { |f| f.start_with? "spec/" }
require "rack/test"

describe RouteResolver do
  include Rack::Test::Methods

  context "GET to '/'" do
    let(:app)      { described_class.new({}) }
    let(:response) { get "/" }

    it { expect(response.status).to eq 405 }
    it { expect(response.body).to include "Invalid request method (must be POST)." }
  end

  context "POST with weird path" do
    let(:app)      { described_class.new({}) }
    let(:response) { post "/somewhere-weird" }

    it { expect(response.status).to eq 404 }
    it { expect(response.body).to include "Invalid request path (must be `/license-key`)." }
  end
end
