class Dog
  attr_accessor :id, :name, :breed

  def initialize(id:nil, name:, breed:)
    @id=id
    @name=name
    @breed=breed
  end

  def self.create_table
    sql=<<-SQL
    CREATE TABLE dogs(
      id INTEGER PRIMARY KEY,
      name TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql=<<-SQL
    DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql=<<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(id:nil, name:, breed:)
    dog=Dog.new(id: id, name: name, breed: breed)
    dog.save
  end

  def self.new_from_db(array)
    Dog.new(id: array[0], name: array[1], breed: array[2])
  end

  def self.find_by_id(id)
    sql=<<-SQL
    SELECT *
    FROM dogs
    WHERE id = ?
    SQL

    dog = DB[:conn].execute(sql, id)
    Dog.new_from_db(dog[0])
  end

  def self.find_or_create_by(dog)
    sql = SELECT * FROM dogs WHERE name = ?, breed = ?

    dog = DB[:conn].execute(sql, dog[:name], dog[:breed])

    if !dog.empty?
      dog
    else
      dog.create(id: dog[0], name: dog[1], breed: dog[2])
    end
  end

  def self.find_by_name(name)
  end

  def update
  end

end
