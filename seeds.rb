require 'sqlite3'

# Drop existing database to seed cleanly
db_filename = "test.db"
File.delete(db_filename) if File.exist?(db_filename)

# Create database
db = SQLite3::Database.new(db_filename)
db.results_as_hash = true

# Create users table
db.execute <<-SQL
  CREATE TABLE users (
    id                    INTEGER PRIMARY KEY,
    email_address         VARCHAR NOT NULL UNIQUE,
    num_license_keys_sent INTEGER DEFAULT 0
  );
SQL

# Create orders table
db.execute <<-SQL
  CREATE TABLE orders (
    id               INTEGER PRIMARY KEY,
    user_id_shop     INTEGER references users(id),
    user_id_customer INTEGER references users(id)
  );
SQL

# Create license_keys table
db.execute <<-SQL
  CREATE TABLE license_keys (
    user_id     INTEGER references users(id),
    license_key VARCHAR NOT NULL
  );
SQL

# Seed users
user_emails = [
  "rey@test.com", "maz@test.com", "jyn@test.com",
  "leia_shop@test.com", "bb8_shop@test.com"
]
user_emails.each do |email|
  db.execute("INSERT INTO users (email_address) VALUES (?);", email)
end

# Grab user ids
rey, maz, jyn, leia, bb8 = db.execute("SELECT * FROM users;")
                             .map { |user| user["id"] }

# Seed orders with user ids
order_pairs = [[leia, rey], [leia, maz], [leia, jyn], [bb8, rey], [bb8, jyn]]
order_pairs.each do |shop, customer|
  db.execute(
    "INSERT INTO orders (user_id_shop, user_id_customer) VALUES (?, ?);",
    shop, customer
  )
end

# Seed license key
key_text = "Quigoncadeskywalkermustafardarthlarssidiousantillesk3poWedgelandowedgemonantillesnaboosolodantooinejawaCadec3poantillesfettlandoackbarDookuleiawookieehuttHuttchewbaccamustafarendorchewbaccajadecalrissianHuttdarthwookieeantillesowenGrievoushuttskywalkermoffcalamarimoff"
db.execute(
  "INSERT INTO license_keys (user_id, license_key) VALUES (?, ?);",
  rey, key_text
)
db.execute(
  "UPDATE users SET num_license_keys_sent = num_license_keys_sent + 1 WHERE id = ?;",
  rey
)

# Print results
puts "USERS"
db.execute("SELECT * FROM users;").each { |user| p user }
puts "ORDERS"
db.execute("SELECT * FROM orders;").each { |order| p order }
puts "LICENSE_KEYS"
db.execute("SELECT * FROM license_keys;").each { |license| p license }

