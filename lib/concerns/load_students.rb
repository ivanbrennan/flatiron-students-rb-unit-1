module LoadStudents

  def load_students
    sql = "SELECT * FROM students"
    @student_list = Student.db.execute(sql)
    if @student_list.size == 0
      IndexScraper.run
      Scraper.scrape_student
    else
      Student.reset_all
      @student_list.each do |student|
        Student.new_from_row(student)
      end
    end
  end

end

