require_all Dir.glob("**/**/*.rb").reject { |f| f.start_with? "spec/" }

describe LicenseKeyEmailer do
  let(:env) { { "REQUEST_METHOD" => "POST" } }
  let(:request) { Rack::Request.new(env) }
  let(:params) do
    {
      "userID" => user_id,
      "userID_customer" => customer_id,
      "licenseKey" => "SOME_STRING",
      "orderID" => order_id
    }
  end
  let(:app)         { described_class.new(request) }
  let(:status)      { app.status }
  let(:body)        { app.body }
  let(:user_id)     { "4" }
  let(:order_id)    { "1" }
  let(:customer_id) { "1" }

  before do
    allow(request).to receive(:params) { params }
    allow(request).to receive(:path)   { "/license-key" }
  end

  context "with valid params" do
    it "returns success and a happy message" do
      app.run
      expect(status).to eq 200
      expect(body).to eq "License key for customer 1 saved."
    end

    it "stores the license key and updates the user's license count" do
      expect_any_instance_of(MiniORM)
        .to receive(:store_license_key).and_call_original
      expect_any_instance_of(MiniORM)
        .to receive(:update_license_count_for).and_call_original
      app.run
    end
  end

  context "with invalid params" do
    before { app.run }

    context "bad user" do
      let(:customer_id) { "6" }

      it "returns a 400 and an error message" do
        expect(status).to eq 400
        expect(body).to eq "No user with id 6"
      end
    end

    context "bad order" do
      let(:order_id) { "3" }

      it "returns a 400 and an error message" do
        expect(status).to eq 400
        expect(body).to eq "Invalid match for customer 1 and order 3."
      end
    end
  end
end
