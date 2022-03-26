require './lib/command_parser'

class Program
  class << self
    def execute(argv)
      command = CommandParser.parse(argv)
      command.execute
    end
  end
end