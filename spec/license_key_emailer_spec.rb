require_all Dir.glob("**/**/*.rb").reject { |f| f.start_with? "spec/" }

describe LicenseKeyEmailer do
  let(:env) do
    { "REQUEST_METHOD" => "POST",
      "PATH_INFO" => "/license-key",
      "rack.input" => StringIO.new }
  end
  let(:request) do
    req = Rack::Request.new(env)
    req.update_param("userID", user_id)
    req.update_param("userID_customer", customer_id)
    req.update_param("licenseKey", "SOME_STRING")
    req.update_param("orderID", order_id)
    req
  end
  let(:app)    { described_class.new(request) }
  let(:status) { app.status }
  let(:body)   { app.body }

  context "POST to /license-key" do
    let(:user_id)     { "4" }
    let(:order_id)    { "1" }
    let(:customer_id) { "1" }

    context "with valid params" do
      it "succeeds" do
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
end
