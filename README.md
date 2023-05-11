# Slack Bot
This is a Slack bot built using Ruby on Rails. The bot is designed to listen to specific commands like /rootly declare and /rootly resolve.

## Usage in production:
1. Access this link and add the bot to a slack workspace:  
[Add bot to a slack workspace](https://slack.com/oauth/v2/authorize?client_id=5240890931682.5253551678529&scope=channels:join,channels:manage,channels:read,channels:write.invites,chat:write,chat:write.public,commands,groups:read,groups:write,im:read,im:write,users:read,users:read.email,groups:history&user_scope=)
2. Run /rootly declare in any public channel and complete the dialog form with a title, description, and severity level. Only the title is mandatory. It will create a new channel for the incident. You can also run the command in private channels if you add the application to that channels.
3. Run /rootly resolve in any incident channel. It will send a message with the time consumed to resolve the incident and will archive the channel.
4. Visit the production url(because I'm using a free version of render, the server is stopping randomly from time to time. Also, the first load takes more time...): [https://rootly-slack-bot.onrender.com/](https://rootly-slack-bot.onrender.com/) in order to see the created incidents. You can also sort them alphabetically ASC/DESC.



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
