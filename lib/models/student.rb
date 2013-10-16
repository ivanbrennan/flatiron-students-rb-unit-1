require 'sqlite3'
require 'pry'

class Student
  attr_accessor :name, :twitter, :linkedin, :facebook, :website
  attr_reader :id

  ATTRIBUTES_HASH = {
    :id => "INTEGER PRIMARY KEY AUTOINCREMENT",
    :name => "TEXT",
    :twitter => "TEXT",
    :linkedin => "TEXT",
    :facebook => "TEXT",
    :website => "TEXT"
  }

  @@students = []

  @@db = SQLite3::Database.new('students.db')
  create = "CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
  @@db.execute(create)

  def get_newest_id
    sql = "SELECT MAX(id) FROM students"
    @@db.execute(sql).flatten[0].to_i
  end

  def initialize(id=nil)
    @@students << self
    @saved = false
    @id = id if id
  end

  def self.reset_all
    @@students.clear
  end

  def self.all
    @@students
  end

  def self.db_reset
    sql = "DROP TABLE IF EXISTS students"
    @@db.execute(sql)
    create = "CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
  end

  def self.attributes_for_db
    ATTRIBUTES_HASH.keys.reject {|k| k == :id}
  end

  def self.find_by_name(name)
    @@students.select { |s| s.name == name }
  end

  def set_id(db_id)
    @id = db_id
  end

  def self.find(id)
    sql = "SELECT * FROM students WHERE id = ?"
    row = @@db.execute(sql, id)
    found = Student.new(row.flatten[0])
    found.name = row.flatten[1]
    found
  end

  def self.delete(id)
    @@students.reject! { |s| s.id == id}
  end

  def saved?
    @saved
  end

  def save
    if saved?
      self.update
    else
      self.set_id(get_newest_id + 1)
      self.insert
    end
  end

  def insert
    sql = "INSERT INTO students (name) VALUES (?)"
    @@db.execute(sql, self.name)
    @saved = true
  end

  def update
    sql = "UPDATE students SET name = ? WHERE id = ?"
    @@db.execute(sql, self.name, self.id)
    true
  end

  def self.load(id)
    sql = "SELECT * FROM students WHERE id = ?"
    row = @@db.execute(sql, id)
    loaded = Student.new(row.flatten[0])
    loaded.name = row.flatten[1]
    loaded
  end

  def ==(other_student)
    self.id == other_student.id
  end

end
