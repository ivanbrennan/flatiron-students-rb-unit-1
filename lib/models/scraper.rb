require_relative '../../config/environment'

class Scraper

  # get each student URL from index page
  # 

  @@index_url = "http://students.flatironschool.com"

  def self.scrape_student(url=nil)
    @noko_doc = Nokogiri::HTML(File.open("resources/raymond_gan.html"))
    # will scrape a page, get the attributes we want,
    # and put them into a Student.new
    name = scrape_name
    title_pic = scrape_title_pic
    profile_pic = scrape_profile_pic
    big_name = scrape_

    # profile picture, big name,
    # twitter, linkedin, github, rss, quote,
    # about
    # 'coder cred' section
    # 'recently' section
    # 'favorites' section
    # SCRAPE
  end

  def self.scrape_name
    @noko_doc.css('.link-subs span').text
  end

  def self.scrape_title_pic
    @noko_doc.xpath("//style").text  # this gives us e'rything btw the style tags in background
  end

  def self.scrape_profile_pic
    "http://www.students.flatironschool.com/#{@noko_doc.css('img.student_pic').attr('src').text}"
  end
end

Scraper.scrape_student