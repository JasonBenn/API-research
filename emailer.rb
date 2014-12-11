require 'yaml'
require 'pony'

module Emailer
  def self.send(options)
    auth = YAML::load(File.open'./auth.yml')
    emails = options[:to]

    emails.each do |recipient|
      begin
        Pony.mail(
          :to => recipient,
          :via => :smtp,
          :via_options => {
            :address => 'smtp.gmail.com',
            :port => '587',
            :enable_starttls_auto => true,
            :user_name => auth['gmail_username'],
            :password => auth['gmail_password'],
            :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
            :domain => "HELO", # don't know exactly what should be here
          },
          :subject => options[:subject],
          :html_body => options[:body]
        )
      rescue Exception => e
        p e
        exit
      end
    end

    puts 'No errors while sending!'
  end
end
