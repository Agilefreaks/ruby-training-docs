require './lib/ruby_gems_api'

class ShowGemCommand
  attr_reader :gem_name

  class ShowGemResult
    attr_reader :gem_name, :description

    def initialize(options)
      @gem_name = options[:gem_name]
      @description = options[:description]
    end
  end

  def initialize(gem_name)
    @gem_name = gem_name
  end

  def execute
    result = RubyGemsApi.gem_info(gem_name)

    ShowGemResult.new(
      gem_name: result['name'],
      description: result['info']
    )
  end
end
