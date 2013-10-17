require_relative '../config/environment'

sql = "SELECT * FROM students"
if Student.db.execute(sql).size == 0
  IndexScraper.run
  Scraper.scrape_student
end
