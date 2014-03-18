require 'pg'

class Task

  def initialize(name, list_id)
    @name = name
    @list_id = list_id
  end

  def name
    @name
  end

  def list_id
    @list_id
  end

  def self.all
    results = DB.exec("SELECT * FROM tasks;")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      tasks << Task.new(name, list_id)
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id, done) VALUES ('#{@name}', #{@list_id}, 'f');")
  end

  def mark_done(task_name)
    DB.exec("UPDATE tasks SET done = 't' WHERE name = '#{task_name}';")
    results = DB.exec("SELECT * FROM tasks WHERE done = 't';")
    done_tasks = []
    results.each do |result|
      name = result['name']
      done_tasks << name
    end
    done_tasks
  end

  # def add_to_list(list_id)
  #   List.all[list_id].list_tasks << self.name
  # end


  def ==(another_task)
    self.name == another_task.name
  end
end
