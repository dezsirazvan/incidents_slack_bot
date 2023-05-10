require 'json'
require 'slack-ruby-client'

class SlackBotController < ApplicationController
  protect_from_forgery except: [:handle, :actions]
  before_action :verify_slack_request

  def actions
    payload = JSON.parse(params[:payload])

    CreateIncident.new(payload).call

    head :ok
  end

  def handle
    command_text = params['text']
    command_name = command_text.split(' ').first

    begin
      result = CommandFactory.call(command_name, params)

      head :ok
    rescue => exception
      render json: { error: exception }, status: :ok
    end
  end

  private

  def verify_slack_request
    signing_secret = ENV['SLACK_SIGNING_SECRET']
    verifier = Slack::Events::Request.new(request, signing_secret: signing_secret)
    head :unauthorized unless verifier.verify!
  end
end