require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name, @grade, @id = name, grade, id
  end

  #Instance methods
  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, name, grade, id)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students
          (name, grade)
        VALUES
          (?, ?);
      SQL

      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students;')[0][0]
      self
    end
  end

  #Class Methods
  def self.create(name, grade)
    new(name, grade).save
  end
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students
      (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    new(row[1], row[2], row[0])
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL

    new_from_db(DB[:conn].execute(sql, name)[0])
  end
end
