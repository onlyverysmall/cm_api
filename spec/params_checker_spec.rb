describe ParamsChecker do
  include Rack::Test::Methods

  context "POST sans params" do
    let(:app)      { described_class.new({}) }
    let(:response) { post "/license-key" }

    it { expect(response.status).to eq 400 }
    it { expect(response.body).to eq "`userID`, `userID_customer`, `licenseKey`, and `orderID` are required." }
  end
end
