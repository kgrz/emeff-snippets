# This snippets builds an index of the links to the RSS feeds of the funds

url = "http://www.amfiindia.com/rssShowFeeds.aspx"

require 'faraday'
require 'nokogiri'
require 'pry'
# File.open("feed_index.html", "w") { |file| file.write Faraday.new(url).get.body }
html = File.read "feed_index.html"
html_doc = Nokogiri::HTML(html)

# funds = html_doc.xpath("//table[@id='ctl00_amfiHomeContent_tblRSSFeed']/tr/td/span[@class='active']")
funds = html_doc.xpath("//td/span[@class='active']").drop(2).map(&:inner_html)
links = html_doc.xpath("//td[@class='label']/a")
indices = (1..links.count).to_a.keep_if(&:even?)
indices.shift
links = links.to_a.values_at(*indices).map { |x| x.get_attribute "href" }
#.map {|x| x.get_attribute "href"}
index = Hash[funds.zip(links)]
pry index
