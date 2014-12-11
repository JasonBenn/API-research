require 'json'
require 'rest_client'
require_relative 'db'


module FundingRounds
  @store = DB.new("funding-rounds.sqlite3")

  def self.fetch_and_parse
    data = JSON.parse(fetch)
    orgs = data['results']['orgs']
    with_hq = orgs.select { |org| org['headquarters'] }
    in_city = with_hq.select { |org| CITIES.any? { |city| org['headquarters']['text'].include? city } }
    new_rounds = in_city.reject { |org| @store.org_in_db?(org['name']['text'], org['latest-round'], org['total-funding']) }
    { with_hq: with_hq, in_city: in_city, new_rounds: new_rounds }
  end

  private

  def self.fetch
    RestClient.get 'https://www.kimonolabs.com/api/5hzt2g4w?apikey=QKhYoTgPaWJb2HNPuTRNAThb9nI6iVKA'
  end
end
