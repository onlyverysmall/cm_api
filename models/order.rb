class Order
  attr_reader :id, :user_id_shop, :user_id_customer

  def initialize(data)
    @id               = data["id"]
    @user_id_shop     = data["user_id_shop"]
    @user_id_customer = data["user_id_customer"]
  end
end
