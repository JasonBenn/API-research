require 'json'
require 'rest_client'
require_relative 'db'


module FundingRounds
  @store = DB.new("funding-rounds.sqlite3")

  def self.fetch_and_parse
    data = JSON.parse(fetch)
    orgs = data['results']['orgs']
    with_hq = orgs.select { |org| org['headquarters'] }
    puts "With an HQ: #{with_hq.map {|org| org['name']['text']} }"
    in_city = with_hq.select { |org| CITIES.any? { |city| org['headquarters']['text'].include? city } }
    puts "In cities: #{in_city.map {|org| org['name']['text']}}"
    new_rounds = in_city.reject { |org| @store.org_in_db?(org['name']['text'], org['latest-round'], org['total-funding']) }
    puts "New rounds: #{new_rounds.map {|org| org['name']['text']}}"
    new_rounds
  end

  private

  def self.fetch
    RestClient.get 'https://www.kimonolabs.com/api/5hzt2g4w?apikey=QKhYoTgPaWJb2HNPuTRNAThb9nI6iVKA'
  end
end
