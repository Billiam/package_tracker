# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
if Account.where(role: 'admin').count == 0
  email     = shell.ask "Which email do you want use for logging into admin?"
  password  = shell.ask "Tell me the password to use:", :echo => false

  shell.say ""

  account = Account.new(:email => email, :password => password, :password_confirmation => password, :role => "admin")

  if account.valid?
    account.save
    shell.say "================================================================="
    shell.say "Account has been successfully created, now you can login with:"
    shell.say "================================================================="
    shell.say "   email: #{email}"
    shell.say "   password: #{?* * password.length}"
    shell.say "================================================================="
  else
    shell.say "Sorry, but something went wrong!"
    shell.say ""
    account.errors.full_messages.each { |m| shell.say "   - #{m}" }
  end

  shell.say ""
end

preferences = {
  'FEDEX_LOGIN' => 'FedEx Meter Number',
  'FEDEX_PASSWORD' => 'FedEx Password',
  'FEDEX_KEY' => 'FedEx Developer key',
  'FEDEX_ACCOUNT' => 'FedEx Account Number',
  'FEDEX_TEST' => '"true" if using FedEx Test Credentials?',

  'GMAIL_USER' => 'Gmail Address for Incoming Tracking Notifications',
  'GMAIL_PASSWORD' => 'Gmail Password',

  'UPS_KEY' => 'UPS Access Key',
  'UPS_ACCOUNT' => 'UPS Account Number',
  'UPS_LOGIN' => 'UPS User ID',
  'UPS_PASSWORD' => 'UPS User Password',

  'USPS_LOGIN' => 'USPS Web Tools Username',
}

preferences.each do |name, description|
  Preference.find_or_create(key: name) { |preference| preference.description = description }
end


