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

  private

  def invalid_request_method
    [405, {}, ["Invalid request method (must be POST)."]]
  end

  def not_found
    [404, {}, ["Invalid request path (must be `/license-key`)."]]
  end
end
