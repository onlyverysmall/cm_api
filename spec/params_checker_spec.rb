require_all Dir.glob("**/**/*.rb").reject { |f| f.start_with? "spec/" }
require "rack/test"

describe ParamsChecker do
  include Rack::Test::Methods

  context "POST sans params" do
    let(:app)      { described_class.new({}) }
    let(:response) { post "/license-key" }

    it { expect(response.status).to eq 400 }
    it { expect(response.body).to include "bad request" }
  end
end
