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
    twitter = scrape_twitter
    linkedin = scrape_linkedin
    github = scrape_github
    quote = scrape_quote
    about = scrape_about
  end

  def self.scrape_name
    @noko_doc.css('.link-subs span').text
  end

  def self.scrape_title_pic
    @noko_doc.xpath("//style").text  # this gives us e'rything btw the style tags in background
  end

  def self.scrape_profile_pic
    "http://www.students.flatironschool.com/#{(@noko_doc.css('img.student_pic').attribute('src').text)[3..-1]}"
  end

  def self.scrape_twitter
    @noko_doc.css('div.social-icons a')[0].attribute('href').to_s
  end

  def self.scrape_linkedin
    @noko_doc.css('div.social-icons a')[1].attribute('href').to_s
  end

  def self.scrape_github
    @noko_doc.css('div.social-icons a')[2].attribute('href').to_s
  end

  def self.scrape_quote
    @noko_doc.css('.quote-div h3').text
  end

  def self.scrape_about
    ### NOT WORKING ###
    @noko_doc.css('div#scroll-about div.ok-text-column').to_s
  end

end

Scraper.scrape_student