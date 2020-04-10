require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []
    page.css(".student-card a").each do |student|
      students << {location: student.css(".student-location").text, name: student.css(".student-name").text, profile_url: "#{student.attr('href')}"}
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    profile = {}
    links = page.css("div.social-icon-container a").map { |element| element.attribute('href').value}
    links.each do |link|
      if link.include?("twitter")
        profile[:twitter] = link
      elsif link.include?("linkedin")
        profile[:linkedin] = link
      elsif link.include?("github")
        profile[:github] = link
      else 
        profile[:blog] = link
      end 
    end 
    profile[:bio] = page.css("div.bio-content.content-holder div.description-holder p").text if page.css("div.bio-content.content-holder div.description-holder p")
    profile[:profile_quote] = page.css(".profile-quote").text if page.css(".profile-quote")
    profile
  end
end

