require_relative '../config/environment'

class CLIStudent

  include LoadStudents
  
  def initialize(students)
    @students = students
    @on = true
  end

  def on?
    @on
  end

  def input
    gets.strip
  end

  def call
    load_students
    system('clear')
    puts IndexScraper.msg
    puts "#{Student.all.size} students loaded."
    print "Type a command ('help' for help): "
    while self.on?
      self.process(input)
    end
  end

  def browse
    system('clear')
    puts "STUDENTS".center(Student.all.first.name.length + 4, " ")
    #puts "----------------------------------------".center(40, ' ')
    puts ""
    print "id.".ljust(13, ' ')
    puts "name"
    print "--- "
    print "-"*Student.all.first.name.length
    puts ""
    Student.all.each do |student|
      puts "#{(student.id.to_s + '.').rjust(3, ' ')} #{student.name}"
    end
    puts ""
    print "Enter a command: "
  end

  def process(command)
    if [:help, :browse, :exit].include?(command.strip.downcase.to_sym)
      self.send(command)
    elsif command.strip.downcase.include?("show")
      if command.split('show').size > 0
        self.show(command.split('show').last.strip)
      else
        puts "Please enter a student's name or ID after 'show'"
        puts "Loading students..."
        sleep(1.5)
        self.browse
      end
    else
      system('clear')
      puts "Sorry, I don't understand. Please try again."
      puts "Loading help..."
      sleep(1.5)
      self.help
    end
  end

  def help
    system('clear')
    puts "Here's how you get around"
    puts "-------------------------"
    puts "<'help'> to see this list of commands"
    puts "<'browse'> to list the students you can view"
    puts "<'show student_name/id'> to see a student's info"
    puts "<'exit'> to exit."
    puts "-------------------------"
    puts ""
    print "Enter a command: "
  end

  def exit
    puts "Bye!"
    @on = false
  end

  def make_array(student)
    if student.is_a?(Array)
      return student
    else
      [student]
    end
  end

  def display(student)
    system('clear')
    if make_array(student).size == 0
      puts "Sorry, I can't find that student. Please try again."
      puts "Loading students..."
      sleep(1.5)
      self.browse
    else
      make_array(student).each do |student|
        puts "Viewing Student"
        puts "---------------"
        puts ""
        puts "Name: #{student.name}"
        puts "Twitter: #{student.twitter}"
        puts "Linkedin: #{student.linkedin}"
        puts "Githhub: #{student.github}"
        puts "Website: #{student.url}"
        puts ""
      end
    end
    print "Enter a command: "
  end

  def show(name)
    if name.to_i.to_s == name
      if name.to_i.between?(1, @student_list.size)
        self.display(Student.find_by_id(name.to_i))
        Student.all.pop
      else
        puts "Sorry, I can't find that student. Please try again."
        puts "Loading students..."
        sleep(1.5)
        self.browse
      end
    else
      self.display(Student.find_by_name(name))
    end
  end

end

command_line = CLIStudent.new(Student.all)
command_line.call