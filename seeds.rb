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
