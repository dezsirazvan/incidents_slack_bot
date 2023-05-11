Rails.application.routes.draw do
  root to: 'incidents#index'

  post '/slackbot', to: 'slack_bot#handle'
  post '/slackbot/actions', to: 'slack_bot#actions'

  get '/slack_oauth/callback', to: 'slack_oauth#callback'
end
