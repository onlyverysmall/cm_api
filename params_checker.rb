class ParamsChecker
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    @params = request.params

    required_params_present? ? @app.call(env) : bad_request
  end

  private

  def required_params_present?
    required_params = ["userID", "userID_customer", "licenseKey", "orderID"]
    required_params.all? { |key| @params[key] && !@params[key].empty? }
  end

  def bad_request
    [400, {}, ["`userID`, `userID_customer`, `licenseKey`, and `orderID` are required."]]
  end
end
