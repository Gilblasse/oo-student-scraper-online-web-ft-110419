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
    socials = parse_social_links(doc)
    {}
    binding.pry
  end
  
  def parse_social_links(doc)
    keys = [:twitter, :linkedin, :github]
    links = doc.css(".social-icon-container")
    socials = links.css("a").map{|a|a['href'].match(/(?!\W|w)\w*(?=.c)/).to_s}.zip(links.css("a").map{|a|a['href']}).to_h
    socials.map {|k,v| keys.include?(k.to_sym) ? [k,v] : [k="blog",v]}.to_h
  end

end

