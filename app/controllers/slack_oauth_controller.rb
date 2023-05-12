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

      team_id = response.dig('team', 'id')
      Team.create(team_id: team_id, token: access_token)

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
