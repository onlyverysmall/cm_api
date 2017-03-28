class User
  attr_reader :id, :email_address, :num_license_keys_sent

  def initialize(data)
    @id                    = data["id"]
    @email_address         = data["email_address"]
    @num_license_keys_sent = data["num_license_keys_sent"]
  end
end
