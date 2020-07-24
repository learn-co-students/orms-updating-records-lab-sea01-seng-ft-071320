require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade 
  end


  def self.create_table 
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql ="DROP TABLE students"
    
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
  else
   
    sql = "INSERT INTO students (name, grade) VALUES (?, ?);"

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end


  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


  def self.create(name, grade)
    sql = "INSERT INTO students (name, grade) VALUES (?,?); "

    DB[:conn].execute(sql, name, grade)
  end



  def self.new_from_db(row)
    
    id = row[0]
    name = row[1]
    grade = row[2]

    student = self.new(id, name, grade)

    student 

  end

  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT * 
      FROM students
      WHERE name = ?
      SQL

    DB[:conn].execute(sql, name).map do | row|
      self.new_from_db(row)
    end.first 


  end

end # end class
