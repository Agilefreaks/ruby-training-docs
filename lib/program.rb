class Program
  class << self
    def execute(*args)
      raise NotImplementedError
    end
  end
end