class Dog 
  attr_accessor :name, :breed, :id
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
      SQL
      DB[:conn].execute(sql)
     
  end
  
    def self.drop_table
    sql = <<-SQL 
      DROP TABLE dogs
      SQL
      DB[:conn].execute(sql)
  end
  
  def save
    if Dog.id
      Dog.update
    else
    sql = <<-SQL 
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, Dog.name, Dog.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end
  
  def self.create(name:, breed:)
    dog = Dog.new(name, breed)
    dog.save
    dog
  end
  
  def self.find_by_id(id)
    sql = <<-SQL 
    SELECT * FROM dogs WHERE id = ?
    SQL

    result = DB[:conn].execute(sql, id)[0]
    Dog.new(result[0], result[1], result[2])
  end
  
  def update
    sql = <<-SQL 
    UPDATE dogs SET name = ?, breed = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
end