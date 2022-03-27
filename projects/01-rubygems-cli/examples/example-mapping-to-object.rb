# frozen_string_literal: true

class ApiGem
  attr_accessor :name
  attr_accessor :version

  def initialize(name:, version:)
    @name = name
    @version = version
  end
end


parsed_data = [ {name: "TestGem", version: 2}, {name: "SecondTest", version: 4}]

# This is not the only way to do this
gems = parsed_data.map { |data| ApiGem.new(**data) }

pp gems
