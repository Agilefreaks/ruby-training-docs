class CommandParser
  class << self
    def parse(argv)
      ShowGemCommand.new(argv[1])
    end
  end
end