require "open-uri"
require "Nokogiri"
require "sqlite3"

# this should be in the scraper file
# students_array = Nokogiri::HTML(open(profile_url))

# Open a database
def create_db
  SQLite3::Database.new "flatiron.db"
end

db = create_db

def create_table(database)
  rows = database.execute <<-whatever
    CREATE TABLE IF NOT EXISTS students (
      name TEXT,
      bio TEXT
    );
  whatever
end

create_table(db)

def parse_profile(student_hash, db)
  # Insert data
  student_hash.each do |key, value|
    db.execute "insert into students (#{key}) values (?)", value
  end
end

students_array = {"Vivian Shangxuan Zhang" => {
  :student_social_links=>["https://twitter.com/vivian__zhang", "http://www.linkedin.com/in/shangxuanzhang", "https://github.com/casunlight", "https://www.facebook.com/shangxuan.zhang"], :quote=>"\"It is the age of Data Mining. Embrace it with all heart.\" -- Vivian Zhang Said this.", :biography=>"I was born and raised up in Shanghai and came to US for college. I stuided and worked in Sillicon Valley, Long Island, Rhode Island, and now happily study and work in Manhattan.", :education=>"Stony Brook University, San Jose State University", :work_company=>"", :work_blurb=>"I am Co-founder and CTO of a statistical consulting firm--Supstat Inc. Our services include consulting and training on data mining, statistical computing  and visualization. We all program in R. Our lead data scientist is ranked top 0.1% by Kaggle.", :coder_links=>["http://www.github.com/casunlight", "http://teamtreehouse.com/vivianzhang", "http://www.codeschool.com/users/shangxuan", "https://coderwall.com/shangxuan"], :blogs=>["http://www.supstat.com/en", "http://www.meetup.com/nyc-open-data", "http://www.statcodebank.com/"], :favorite_sites=>["#", "#", "#", "#"], :personal_projects_links=>[], :personal_projects_text=>"I run a very popular meetup group--NYC Open Data. The goal of the group is to use data and visualizations to tell stories about the NYC and develop individual's skill using open data as examples. The group hosts excellent tech and policy talks and gathers devoted programmers,statisticians and data scientists to teach and help each other to develop data mining and visualization skills.", :flatiron_projects_text=>"I plan to upgrade www.supstat.com and make www.nycopendata.com home of open data hack projects, developer network, repository of workshops material, and open data providers.", :favorite_cities=>["Shanghai", "London", "Hawaii", "New York"]}}

students_array.each do |student|
  parse_profile(student, db)
end