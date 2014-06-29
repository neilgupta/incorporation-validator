require 'scraper.rb'

class HooverProxy < Scraper

  def validate_company(company)
    page = search_web_page("http://www.hoovers.com/company-information/company-search.html?term=",company)
    array_of_links = search_links(page, company)
    link = array_of_links.first
    return nil if array_of_links.empty?
    name = link.text
    page_2 = get_web_page(link.href)
    page_2_content = Nokogiri::HTML(page_2.content)
    hash = {
      :name => name.strip,
      :address => {
        :street => page_2_content.xpath('//span[@itemprop="streetAddress"]').text.strip,
        :city => page_2_content.xpath('//span[@itemprop="addressLocality"]').first.text.strip,
        :state => page_2_content.xpath('//span[@itemprop="addressRegion"]').first.text.strip,
        :country => page_2_content.xpath('//span[@itemprop="addressCountry"]').first.text.strip,
        },
      :phone_number => page_2_content.xpath('//span[@itemprop="telephone"]').first.text.strip,
      :tags => page_2_content.xpath('//div[@class="tag-container"]/a[@class="tag"]').map {|tag| tag.text.strip}
    }
  end

  def validate_user(user,company)
    page = search_web_page("http://www.hoovers.com/company-information/cs/people-search.html?term=","#{user} #{company}")
    array_of_links = search_links(page, user)
    return nil if array_of_links.empty?
    link = array_of_links.first
    name = link.text
    page_content = Nokogiri::HTML(page.content)

    hash = {
      :name => name.strip,
      :title => page_content.xpath('//*[@id="shell"]/div/div/div[2]/div[3]/div/div/div[1]/table/tbody/tr[1]/td[2]').text.strip,
      :company => page_content.xpath('//*[@id="shell"]/div/div/div[2]/div[3]/div/div/div[1]/table/tbody/tr[1]/td[3]').text.strip
    }
  end

  def validate(company, user = nil)
    validated_user = user ? validate_user(user,company) : nil
    {
      :company => validate_company(validated_user.try(:[], :company) || company),
      :user => validated_user
    }
  end
end
