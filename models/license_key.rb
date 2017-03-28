class LicenseKey
  attr_reader :user_id, :license_key

  def initialize(data)
    @user_id     = data["user_id"]
    @license_key = data["license_key"]
  end
end
