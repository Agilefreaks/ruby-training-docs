class ShowGemCommand
  attr_reader :gem_name

  def initialize(gem_name)
    @gem_name = gem_name
  end
end
