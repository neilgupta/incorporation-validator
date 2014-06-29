require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'cgi/util'

class Scraper

  def initialize
    @agent = Mechanize.new
  end

  #returns a web page
  def search_web_page(base_url,company)
    @agent.get("#{base_url}#{CGI::escape(company)}")
  end

  def get_web_page(url)
    @agent.get(url)
  end

  # returns an array of all links with the specified content
  def search_links(page,content)
    page.links_with( :text => Regexp.new(content, true))
  end
end
