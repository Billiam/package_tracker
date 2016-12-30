# Package Tracker

Fetch tracking information and delivery schedule for inbound packages, and display on a simple dashboard.

## Installation

```bash
# install dependencies
bundle install

# Set up environment
cp dotenv.dist .env

# Edit .env file, setting your database url and session secret.

# Set up your database
bundle exec rake db:create
bundle exec rake db:migrate

# Seed database to create admin user and preference storage
bundle exec rake db:seed

# Start the application
bundle exec padrino s
```

## Setup
Create a Gmail account to receive shipping notifications. 
All unread email will be marked as read by the rake process.

Create api accounts with 
[FedEx](http://www.fedex.com/us/developer/web-services/index.html),
[UPS](https://www.ups.com/upsdeveloperkit), and 
[USPS](https://www.usps.com/business/web-tools-apis/welcome.htm), and hang onto your credentials.

Register for email shipment notifications to the above Gmail account with 
[FedEx Delivery Manager](https://www.fedex.com/us/delivery), 
[UPS My Choice](https://www.ups.com/mychoice), and 
[My USPS](https://my.usps.com).

Visit `http://localhost:3000/admin/preferences`, and add your api keys and credentials.

Create cron tasks which will poll your Gmail inbox and update tracking information:

```
*/30 * * * * cd /path/to/project && /path/to/bundle exec rake read_mailbox > /dev/null
*/30 * * * * cd /path/to/project && /path/to/bundle exec rake update_tracking > /dev/null
```

Visit `http://localhost:3000` to view your dashboard.

