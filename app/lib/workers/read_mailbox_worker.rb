class ReadMailboxWorker
  def perform
    require 'mechanize'

    login_page = agent.get('https://reg.usps.com/entreg/LoginAction_input')

    login_form = login_page.form('loginForm')
    login_form.username = auth[:username]
    login_form.password = auth[:password]
    login_form.submit

    agent.post(
      'https://reg.usps.com/entreg/json/AuthenticateAction',
      'username' => auth[:username],
      'password' => auth[:password]
    )

    inbox_page = agent.get('https://informeddelivery.usps.com/box/pages/secure/HomeAction_input.action')
    image_paths = inbox_page.search('.mailImageBox img').map {|i| i['src'] }
    image_paths.each do |path|
      temp_path = agent.get(path).save Padrino.root("tmp/trackify/temp-download-#{Time.now.strftime('%Y%m%d')}")

      File.open(temp_path) do |file_handle|
        image = MailImage.new
        image.identifier = path
        image.photo = file_handle
        image.save
      end

      File.unlink(temp_path)
    end
  end

  private

  def agent
    @agent ||= Mechanize.new.tap do |mechanize|
      mechanize.user_agent_alias = 'Windows Chrome'
    end
  end

  def auth
    {
      username: credentials.USPS_USERNAME,
      password: credentials.USPS_PASSWORD
    }
  end

  def credentials
    @credentials ||= Preference.preference_object
  end
end
