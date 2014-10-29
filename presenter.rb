CITIES = ['San Mateo', 'Foster City', 'South San Francisco', 'Burlingame', 'Redwood City', 'Belmont', 'San Carlos']

module Presenter
  def self.rounds_to_html(rounds)
    if rounds.any?
      email = rounds.reduce({ subject: [], body: [] }) do |email, org|
        name = org['name']['text']
        city = org['headquarters']['text']
        total_funding = org['total-funding']
        link = org['name']['href']

        subject = email[:subject] << name
        body = email[:body] << format_org_blurb(name, city, total_funding, link)
        email
      end

      subject = 'Newly funded: ' + email[:subject].join(', ')
      body = describe_cities + format_list(email[:body])
    else
      subject = "No new funding rounds today in your cities. EOM"
      body = "Checked: " + CITIES.join(', ')
    end
    [subject, body]
  end

  private

  def self.format_org_blurb(name, city, total_funding, link)
    "<a href='#{link}'>#{name}</a> of #{city}. Total funding: #{total_funding}."
  end

  def self.wrap_with_tag(tag, content)
    "<#{tag}>" + content + "</#{tag}>"
  end

  def self.format_list(arr)
    lis = arr.map { |item| wrap_with_tag('li', item) }.join
    wrap_with_tag('ul', lis)
  end

  def self.format_p(text)
    wrap_with_tag('p', text)
  end

  def self.describe_cities
    format_p('Searching in ' + CITIES.join(', ') + '.')
  end

end

