require 'sqlite3'

class DB
  def initialize(file)
    @db = SQLite3::Database.new file
    begin
      @db.execute 'CREATE TABLE funding_rounds ( org_name varchar(128), latest_round varchar(128), total_funding varchar(128) UNIQUE ON CONFLICT IGNORE )'
    rescue SQLite3::SQLException => e
      count = @db.execute('select * from funding_rounds').count
      puts e.message + '. # of existing records: ' + count.to_s
    end
  end

  def self.save_rounds(rounds)
    rounds.each { |org| @db.save(org['name']['text'], org['latest-round'], org['total-funding']) }
  end

  def save(org_name, latest_round, total_funding)
    @db.execute(
      "INSERT INTO funding_rounds ( org_name, latest_round, total_funding ) VALUES ( ?,?,? )",
      org_name, latest_round, total_funding
    )
  end

  def org_in_db?(org_name, latest_round, total_funding)
    @db.execute(
      "SELECT org_name, latest_round, total_funding FROM funding_rounds WHERE org_name = ? AND latest_round = ? AND total_funding = ?",
      org_name, latest_round, total_funding
    ).any?
  end
end
