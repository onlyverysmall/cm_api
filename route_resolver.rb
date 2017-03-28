class RouteResolver
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.post?
      request.path == "/license-key" ? @app.call(env) : not_found
    else
      invalid_request_method
    end
  end

  def invalid_request_method
    [405, {}, ["invalid request method"]]
  end

  def not_found
    [404, {}, ["not found"]]
  end
end
