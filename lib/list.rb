require 'pry'

class List
  def initialize(name, id=nil)
    @name = name
    @id = id
  end

  def name
    @name
  end

  def self.all
    results = DB.exec("SELECT * FROM lists;")
    lists = []
    results.each do |result|
      name = result['name']
      lists << List.new(name)
    end
    lists
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def id
    @id
  end

  def self.list_tasks (list_id)
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{list_id};")
    @list_tasks = []
    results.each do |result|
      name = result['name']
      @list_tasks << name
    end
    @list_tasks
  end

  def ==(another_list)
    self.name == another_list.name
  end
end
