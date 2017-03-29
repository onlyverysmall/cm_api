class LicenseKeyEmailer
  attr_reader :request, :params, :customer, :order, :headers, :error

  def initialize(request)
    @request = request
    @params  = request.params
    @headers = { "Content-Type" => "text/html" }
  end

  def run
    @customer = db.find_user(params["userID_customer"])
    @order    = db.find_order(params["orderID"])

    if valid_order?
      save_license # and then email the license key, asyncronously
    else
      @error = "Invalid match for customer #{ customer.id } and order #{ order.id }."
    end
  rescue MiniORM::RecordNotFound => e
    @error = e.message
  end

  def status
    error ? 400 : 200
  end

  def body
    error ? error : "License key for customer #{ customer.id } saved."
  end

  private

  def db
    @db ||= MiniORM.new
  end

  def valid_order?
    (order.user_id_customer == customer.id) && (order.user_id_shop == params["userID"].to_i)
  end

  def save_license
    db.store_license_key(customer, params["licenseKey"])
    db.update_license_count_for(customer)
  end
end

class LicenseKeyEmailer::Rack
  def call(env)
    request = Rack::Request.new(env)
    app = LicenseKeyEmailer.new(request)

    app.run

    [app.status, app.headers, [app.body]]
  end
end
