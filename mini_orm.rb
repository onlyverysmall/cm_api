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
end
