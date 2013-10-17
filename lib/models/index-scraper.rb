require_relative '../../config/environment'

class IndexScraper

  # scrape students index page
  @@students_index = Nokogiri::HTML(open("http://students.flatironschool.com"))


  def self.run
    get_names
    get_links
    get_tags
    get_img
    get_excerpt
    make_students
  end
  
  def self.get_names
    @student_links = @@students_index.css('.home-blog-post').collect do |student|
      student.css('a').text
    end
  end

  # create array of student links

  def self.get_links
    @student_links = @@students_index.css('.home-blog-post').collect do |student|
      student.css('a').attr('href').to_s
    end
  end

  def self.get_tags
    # create array of student taglines
    @student_taglines = @@students_index.css('.home-blog-post-meta').collect do |student|
      student.text
    end
  end

    # create array of student image links, assigning '#' if one doesn't exist
  def self.get_img
    @student_images = @@students_index.css('.home-blog-post').collect do |student|
      student.css('img').attr('src').text
    end
  end

  def self.get_excerpt
    @student_excerpts = @@students_index.css('.excerpt').collect do |student|
      student.css('p').text
    end
  end

  def self.make_students
    @student_links.each_with_index do |s_link, i|
      student = Student.new.tap do |s|
        s.url = s_link
        s.index_img = @student_images[i]
        s.tag = @student_taglines[i]
        s.excerpt = @student_excerpts[i]
      end
    end
  end

end