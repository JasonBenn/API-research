require 'rake'
require 'pry'

require_relative 'emailer'
require_relative 'funding_rounds'
require_relative 'presenter'

JASMINE = 'jasmine.polson@avisonyoung.com'
JBENN = 'jasoncbenn@gmail.com'
EMAILS = [JBENN, JASMINE]

desc 'check recipients'
task :test do
  rounds = FundingRounds.fetch_and_parse
  subject, body = Presenter.rounds_to_html(rounds)
  puts "\nTO: #{EMAILS.join(', ')}"
  puts "SUBJECT: #{subject}"
  puts "BODY: #{body}\n\n"
end

desc 'check for new funding rounds, and notify by email if any are found'
task :check_funding_rounds do
  rounds = FundingRounds.fetch_and_parse
  subject, body = Presenter.rounds_to_html(rounds)
  Emailer.send({ subject: subject, body: body, to: EMAILS })
  DB.save_rounds(rounds)
end

task default: :check_funding_rounds
