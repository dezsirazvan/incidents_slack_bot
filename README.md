# Slack Bot
This is a Slack bot built using Ruby on Rails. The bot is designed to listen to specific commands like /rootly declare and /rootly resolve.


## Prerequisites
Before running the bot, you will need the following:

Ruby 2.7+
Rails 6.1+
A Slack workspace with administrative access,
A Slack app with the necessary permissions and scopes,
A database to store data, such as PostgreSQL
## Installation
Clone the repository to your local machine.
Install the necessary dependencies by running bundle install.
Create the database by running rails db:create.
Run any pending migrations by running rails db:migrate.
Set up the necessary environment variables in your .env file. These may include:
SLACK_APP_TOKEN: Your Slack app token.
SLACK_BOT_TOKEN: Your Slack bot token.
SLACK_SIGNING_SECRET: Your Slack app's signing secret.
SLACK_CLIENT_ID: Your Slack client id.
SLACK_CLIENT_SECRET: Your Slack client secret

You will also need ngrok in order to test it locally and to set the oauth2, interactions, and command links in Slack application dashboard.
Start the server by running ./bin/dev (automatically reload also the CSS changes).
