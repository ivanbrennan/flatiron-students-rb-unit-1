# A program to scrape the flatiron student profiles
# and group them by student.

# 1. Run the program, student-scrape.rb
# 2. open the index page
# 3. scrape each linked student page
# 4. create an instance of a student hash for each profile page

require 'nokogiri'
require 'open-uri'

student_links = [] # an array of links off the index page

student_links.each do |link|
    # create a Nokogiri DOM
    # the open() part won't work with out the Open-URI gem
    flatiron_student = Nokogiri::HTML(open 'http://students.flatironschool.com/students/ivanbrennan.html')

    # the student's name
    # student_name = flatiron_student.css("h4").text # returns name AND work
    student_name = flatiron_student.css("h4.ib_main_header").text.strip.ib_main_header

    # returns an array of the student's social links; it is quantity agnostic
    student_socials = flatiron_student.css("div.social-icons")
    student_social_links = student_socials.css('a').collect do |social|
         social.attr('href')
    end

    # student quote
    student_quote = flatiron_student.css("div.textwidget h3").first.text.strip

    # biography
    student_biography = flatiron_student.css("div.services p").first.text.strip

    # education
    student_education = flatiron_student.css('div.services').children.css("li").collect do |school|
        school.text
    end.join(', ')

    # work
    student_work_company_name = flatiron_student.css('div.services').children.css('h4').text
    student_work_company_blurb = flatiron_student.css('div#ok-text-column-4 p').first.text.strip

    # coder links
    coder_links_array = flatiron_student.css('div.column.fourth a').collect do |link|
        link.attr('href')
    end

    # 

    

end







