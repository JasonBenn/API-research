require 'rake'
require 'rest_client'
require 'pony'
require 'pry'
require 'yaml'

JASMINE = 'jasmine.polson@avisonyoung.com'
JBENN = 'jasoncbenn@gmail.com'
EMAILS = [JBENN]
CITIES = ['San Mateo', 'Foster City', 'South San Francisco', 'Burlingame', 'Redwood City', 'Belmont', 'San Carlos']


def send_email(to, subject, body)
  auth = YAML::load(File.open'./auth.yml')

  begin
    Pony.mail(:to => to, :via => :smtp, :via_options => {
      :address => 'smtp.gmail.com',
      :port => '587',
      :enable_starttls_auto => true,
      :user_name => auth['gmail_username'],
      :password => auth['gmail_password'],
      :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain => "HELO", # don't know exactly what should be here
      },
      :subject => subject, :html_body => body)
  rescue Exception => e
    p e
  end
  puts "sent. TO: #{to} BODY: #{body}"
end

def format_org_blurb(name, city, total_funding, link)
  "<a href='#{link}'>#{name}</a> of #{city}. Total funding: #{total_funding}."
end

module HTML
  class << self
    def wrap_with_tag(tag, content)
      "<#{tag}>" + content + "</#{tag}>"
    end

    def format_list(arr)
      lis = arr.map { |item| wrap_with_tag('li', item) }.join
      wrap_with_tag('ul', lis)
    end

    def format_p(text)
      wrap_with_tag('p', text)
    end
  end
end

module View
  class << self
    def describe_cities
      HTML.format_p('Searching in ' + CITIES.join(', ') + '.')
    end
  end
end

desc 'check for new funding rounds, and notify by email if any are found'
task :check_funding_rounds do
  subject = []
  body = []

  data = JSON.parse(RestClient.get 'https://www.kimonolabs.com/api/5hzt2g4w?apikey=QKhYoTgPaWJb2HNPuTRNAThb9nI6iVKA')
  orgs = data['results']['orgs']
  with_hq = orgs.select { |org| org['headquarters'] }
  results = with_hq.select { |org| CITIES.any? { |city| org['headquarters']['text'].include? city } }

  if results.any?
    email = results.reduce({ subject: [], body: [] }) do |email, org|
      name = org['name']['text']
      city = org['headquarters']['text']
      total_funding = org['total-funding']
      link = org['name']['href']

      subject = email[:subject] << name
      body = email[:body] << format_org_blurb(name, city, total_funding, link)
      email
    end

    subject = 'Newly funded: ' + email[:subject].join(', ')
    body = View.describe_cities + HTML.format_list(email[:body])

    EMAILS.each do |recipient|
      puts "recipient: #{recipient}. subject: #{subject} body: #{body}."
      send_email(recipient, subject, body)
    end
  else
    EMAILS.each do |recipient|
      send_email(recipient, "No new funding rounds today in your cities. EOM", "")
    end
  end


end

task default: :check_funding_rounds
