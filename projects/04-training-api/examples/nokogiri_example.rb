require 'nokogiri'
# XPath: https://devhints.io/xpath
# Nokogiri: https://nokogiri.org/#parsing-and-querying

require 'open-uri' # Load content from URL

doc = Nokogiri::HTML(URI.open('https://12ft.io/'))
url = doc.xpath('//meta[@property="og:url"]').first['content']
title = doc.xpath('//meta[@property="og:title"]').first['content']
image = doc.xpath('//meta[@property="og:image"]').first['content']
description = doc.xpath('//meta[@property="og:description"]').first['content']

p "URL: #{url}"
p "Title: #{title}"
p "Image: #{image}"
p "Description: #{description}"

