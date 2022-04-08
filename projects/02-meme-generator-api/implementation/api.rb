# frozen_string_literal: true

require './lib/meme_generator_api'

class API
  def self.run
    #uri_string = 'https://blog.theclymb.com/wp-content/uploads/2016/05/shutterstock_336348722-1-1024x683.jpg'
    uri_string = 'https://b-van.ro/wp-content/uploads/2020/12/Post1-Van-Life-5-beneficii-cover-v3.jpg'
    text = 'Home is where you park it'
    MemeGeneratorAPI.execute(uri_string, text)
  end
end

API.run
