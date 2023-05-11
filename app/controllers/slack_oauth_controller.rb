require 'slack_client'

class SlackOauthController < ApplicationController
  def callback
    if params[:error]
      flash[:error] = "Authorization failed: #{params[:error]}"
      redirect_to root_path
      return
    end

    client = SlackClient.client
    response = client.oauth_v2_access(
      client_id: ENV["SLACK_CLIENT_ID"],
      client_secret: ENV["SLACK_CLIENT_SECRET"],
      code: params[:code],
      redirect_uri: slack_oauth_callback_url
    )
  

    if response["ok"]
      access_token = response["access_token"]
      incoming_webhook = response["incoming_webhook"]
      bot_user_id = response.dig("bot_user", "id")
      bot_access_token = response.dig("bot_user", "access_token")
      # Save the access token, incoming webhook URL, bot user ID, and bot access token to the database or session
      flash[:success] = "Authorization succeeded!"
    else
      flash[:error] = "Authorization failed: #{response["error"]}"
    end

    redirect_to root_path
  end

  private

  def slack_oauth_callback_url
    "#{request.base_url}/slack_oauth/callback"
  end
end
