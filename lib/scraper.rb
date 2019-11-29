require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url)).css(".roster-cards-container .student-card")
    students.map do |student| 
      {name: students.css("h4").text, location: students.css("h4 + p").text, profile_url: students.css("a")[0]['href']}
    end
  end

  def self.scrape_profile_page(profile_url)
    
  end

end

