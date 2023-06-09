require 'slack_client'
require_relative '../../app/commands/declare_command'
require_relative '../../app/commands/resolve_command'

class CommandFactory
  COMMANDS = {
    'declare' => DeclareCommand,
    'resolve' => ResolveCommand
  }.freeze

  def self.call(name, data)
    command_class = COMMANDS[name]
    raise ArgumentError.new('Invalid command') unless command_class

    command_class.call(SlackClient.client(data['team_id']), data)
  end
end