require 'sqlite3'

class MiniORM
  DB_FILENAME = "test.db"

  attr_reader :db

  def initialize(filename = DB_FILENAME)
    @db = SQLite3::Database.new(filename)
    @db.results_as_hash = true
  end

  def execute(sql, *args)
    db.execute(sql, *args)
  end

  def find_user(user_id)
    user = execute("SELECT * FROM users WHERE users.id = ?", user_id)
    user.any? ? User.new(user.first) : (raise RecordNotFound, "No user with id #{ user_id }")
  end

  def find_order(order_id)
    order = execute("SELECT * FROM orders WHERE orders.id = ?", order_id)
    order.any? ? Order.new(order.first) : (raise RecordNotFound, "No order with id #{ order_id }")
  end

  def store_license_key(user, license_key_text)
    execute(
      "INSERT INTO license_keys (user_id, license_key) VALUES (?, ?);",
      user.id, license_key_text
    )
  end

  def update_license_count_for(user)
    execute(
      "UPDATE users SET num_license_keys_sent = num_license_keys_sent + 1 WHERE id = ?;",
      user.id
    )
  end

  class RecordNotFound < StandardError
  end
end
