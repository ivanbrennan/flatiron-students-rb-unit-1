require_relative '../../config/environment'

class Scraper

  # get each student URL from index page
  # 

  @@index_url = "http://students.flatironschool.com/"

  def self.scrape_student
    Student.all.each do |student|
      @noko_doc = Nokogiri::HTML(open("#{@@index_url}#{student.url}"))
      student.name = scrape_name
      student.title_pic = scrape_title_pic
      student.profile_pic = scrape_profile_pic
      student.twitter = scrape_twitter
      student.linkedin = scrape_linkedin
      student.github = scrape_github
      student.quote = scrape_quote
      student.main_content = scrape_main_content
      student.save
    end
  end

  def self.scrape_name
    @noko_doc.css('.link-subs span').text
  end

  def self.scrape_title_pic
    @noko_doc.xpath("//style").text  # this gives us e'rything btw the style tags in background
  end

  def self.scrape_profile_pic
    @noko_doc.css('img.student_pic').attribute('src').text
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

  def self.scrape_main_content
    @noko_doc.css('div.container div.this-div-is-just-a-helpful-container').first.to_s.gsub("\n", "")
  end

end