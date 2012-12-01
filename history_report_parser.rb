# Code for parsing the Mutual fund history logs
# The url is of the format:
# "http://www.amfiindia.com/NavHistoryReport_Rpt_Po.aspx?rpt=dn&frmdate=30-Nov-2012&mf=all"
# This reads the data and creates a hash that can be saved as json or any other format
#
require 'nokogiri'
require 'faraday'
require 'pry'
require 'json'

# html = Faraday.new(url).get
# File.open("html.html", "w") {|file| file << html.body}
html = File.read("history_report.html")
html_doc = Nokogiri::HTML(html)

fund_houses = html_doc.xpath("//table/tr[@class='label-BGC']")
fund_house_names  = fund_houses.map { |x| x.elements.inner_html }
funds = {}
fund_house_names.each_with_index do |fund_house_name, index|
  a = fund_houses[index].next_element
  array = []
  until a == fund_houses[index+1] do
    array << a
    a = a.next_element
  end
  names = array.select { |x| x.get_attribute('class')=='labelNAlter-1' }.map do |y|
            y.children.inner_html
  end
  navs = (array - names).map { |x| x.elements.map { |y| y.inner_html } }
  # funds[fund_house_name] = Hash[array.map {|x| x.element_children.map {|y| y.inner_html}}]
  funds [fund_house_name] = Hash[names.zip(navs)]
end

