require_relative '../../config/environment'

class Student
  attr_reader :id

  ATTRIBUTES_HASH = {
    :id => "INTEGER PRIMARY KEY AUTOINCREMENT",
    :name => "TEXT",
    :title_pic => "TEXT",
    :profile_pic => "TEXT",
    :twitter => "TEXT",
    :linkedin => "TEXT",
    :github => "TEXT",
    :quote => "TEXT",
    :main_content => "TEXT",
    :tag => "TEXT",
    :excerpt => "TEXT",
    :index_img => "TEXT",
    :url => "TEXT"
  }

  @@students = []

  @@db = SQLite3::Database.new("#{ProjectRoot}/db/students.db")

  def self.db
    @@db
  end

  def self.att_hash_to_sql_schema
    ATTRIBUTES_HASH.to_a.map {|a| a.join(" ")}.join(", ")
  end

  def self.create_sql
    "CREATE TABLE IF NOT EXISTS students(#{self.att_hash_to_sql_schema})"
  end

  @@db.execute(self.create_sql)

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
    @@db.execute(create_sql)
  end

  def self.attributes_for_db
    ATTRIBUTES_HASH.keys.reject {|k| k == :id}
  end

  def self.find_by_name(name)
    @@students.select { |s| s.name == name }
  end

  def self.attributes
    ATTRIBUTES_HASH.keys
  end

  self.attributes_for_db.each do |attr_name|
    define_method("#{attr_name}=") do |value|
      instance_variable_set("@" + attr_name.to_s, value)
    end
  end

  self.attributes_for_db.each do |attr_name|
    define_method("#{attr_name}") do
      instance_variable_get("@#{attr_name}")
    end
  end

  self.attributes.each do |attr_name|
    define_singleton_method("find_by_#{attr_name}") do |value|
      sql = "SELECT * FROM students WHERE #{attr_name} = ?"
      found = @@db.execute(sql, value).collect { |row| self.new_from_row(row)}
    end
  end

  def self.new_from_row(row)
    student = Student.new(row.flatten[0])
    attributes_for_db.each_with_index do |attr_name, i|
      student.send("#{attr_name}=", row.flatten[i+1])
    end
    student
  end

  def set_id(db_id)
    @id = db_id
  end

  def self.find(id)
    sql = "SELECT * FROM students WHERE id = ?"
    row = @@db.execute(sql, id)
    found = Student.new(row.flatten[0])
    attributes_for_db.each_with_index do |attr_name, i|
      found.send("#{attr_name}=", row.flatten[i+1])
    end
    found
  end

  def delete
    self.class.delete(self.id)
  end

  def self.delete(id)
    @@students.reject! { |s| s.id == id}
    sql = "DELETE FROM students WHERE id = ?"
    @@db.execute(sql,id)
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
    sql = "INSERT INTO students (#{self.class.column_names}) VALUES (#{self.class.question_marks_for_update})"
    @@db.execute(sql, self.column_values)
    @saved = true
  end

  def self.column_names
    attributes_for_db.map { |attribute_name| attribute_name.to_s }.join(",")
  end

  def self.question_marks_for_update
    (["?"] * attributes_for_db.size).join(",")
  end

  def self.sql_for_update
    self.attributes_for_db.map { |attribute_name| "#{attribute_name}= ?"}.join(",")
  end

  def column_values
    self.class.attributes_for_db.map { |attribute_name| self.send(attribute_name)}
  end

  def update
    sql = "UPDATE students SET #{self.class.sql_for_update} WHERE id = ?"
    @@db.execute(sql, self.column_values, self.id)
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
