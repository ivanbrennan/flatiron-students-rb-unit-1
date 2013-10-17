require_relative '../../config/environment'

class Generate

  include LoadStudents
  
  def generate_index
    index = ERB.new(File.open("#{ProjectRoot}/lib/views/index.erb").read)  
    File.open("_site/index.html", "w+") do |f|
      f << index.result
    end
  end

  def call
    load_students
    generate_index
    generate_students
  end

  def generate_students
    student_index = ERB.new(File.open("#{ProjectRoot}/lib/views/student_show.erb").read) 

    Student.all.each do |s|
      File.open("_site/#{s.url}", "w+") do |f|
        f << student_index.result(binding)
      end
    end
  end
end