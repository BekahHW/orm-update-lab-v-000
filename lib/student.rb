require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

 def self.create_table
   sql = <<-SQL  
   CREATE TABLE IF NOT EXISTS students (
   id INTEGER,
   name TEXT,
   grade TEXT)
   SQL
   
   DB[:conn].execute(sql)
 end
 
 def self.drop_table
   sql = <<-SQL
   DROP TABLE students
   SQL
   
   DB[:conn].execute(sql)
 end
   
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
  end

def self.create(name, grade)
   student = Student.new(name, grade)
   student.save
   student
 end

def update
     sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.grade, self.id)
 end
 
 def self.find_by_name(name)
   sql = "SELECT * FROM students WHERE name = ?"
   result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
 end

def self.new_from_db(row)
   new = self.new(id, name, grade) 
   new.id = row[0]
   new.name =  row[1]
   new.grade = row[2]
 new

end


end
