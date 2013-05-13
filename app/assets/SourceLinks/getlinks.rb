require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'

url="http://www.newsisfree.com/sources/bycat/15/Business"
#http://www.newsisfree.com/sources/bycat/104/PR%20Releases
#http://www.newsisfree.com/sources/bycat/23/Health
#http://www.newsisfree.com/sources/bycat/55/Society
#http://www.newsisfree.com/sources/bycat/21/Technology
#http://www.newsisfree.com/sources/bycat/364/Miscellaneous
#http://www.newsisfree.com/sources/bycat/28/Weblog

doc = Nokogiri::HTML(open(url))
link = ""
doc.css("#SiteListPage b a").each do |item|
   #link = item[:href]
   link = "http://www.newsisfree.com" + item[:href]
   #puts link
begin
browser = Selenium::WebDriver.for :firefox # or :ie or :chrome;
browser.navigate.to link
browser.find_element(:css, "img[alt=\"Original XML Source\"]").click
link = browser.current_url()
puts link
browser.quit
rescue
browser.quit()
end
end

