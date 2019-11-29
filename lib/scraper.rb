require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url)).css(".roster-cards-container .student-card")
    students.map do |student| 
      {name: student.css("h4").text, location: student.css("h4 + p").text, profile_url: student.css("a")[0]['href']}
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    socials = self.parse_social_links(doc.css(".social-icon-container"))
    socials.merge!({bio: doc.css(".description-holder p").text,profile_quote: doc.css(".profile-quote").text})
  end
  
  def self.parse_social_links(doc)
    keys = [:twitter, :linkedin, :github]
    socials = doc.css("a").map{|a|a['href'].match(/(?!\W|w)\w*(?=.c)/).to_s}.zip(doc.css("a").map{|a|a['href']}).to_h
    socials.map {|k,v| keys.include?(k.to_sym) ? [k.to_sym,v] : [k="blog".to_sym,v]}.to_h
  end

end

