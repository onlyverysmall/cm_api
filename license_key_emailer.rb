class LicenseKeyEmailer
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def status
    "200"
  end

  def headers
    { "Content-Type" => "application/json" }
  end

  def body
    "A goofytown rack app with some text."
  end
end

class LicenseKeyEmailer::Rack
  def call(env)
    request = Rack::Request.new(env)
    app = LicenseKeyEmailer.new(request)

    [app.status, app.headers, [app.body]]
  end
end
