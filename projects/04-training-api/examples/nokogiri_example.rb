require 'nokogiri'
# XPath: https://devhints.io/xpath
# Nokogiri: https://nokogiri.org/#parsing-and-querying

require 'open-uri' # Load content from URL

doc = Nokogiri::HTML(open('https://12ft.io/'))
doc.xpath('//meta[@property="og:url"]').first['content']