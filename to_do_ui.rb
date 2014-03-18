require './lib/list'
require './lib/task'

DB = PG.connect({:dbname => 'to_do'})

def reset_tables
  DB.exec("TRUNCATE TABLE lists RESTART IDENTITY")
  DB.exec("TRUNCATE TABLE tasks RESTART IDENTITY")
  add_list
end

def main_menu
  puts "Press 'l' to add a new list."
  puts "Press 'e' to edit a list or task."
  puts "Press 'd' to mark a task as done."
  puts "Press 't' to add a new task."
  puts "Press 'x' to leave."
  menu_choice = gets.chomp
  case menu_choice
  when 'l'
    add_list
  when 't'
    add_task
  when 'd'
    finish_task
  when 'e'
    edit_list
  when 'x'
    puts 'Thank You.'
  else
    puts "Please choose again.\n"
    main_menu
  end
end

def add_list
  print "Add List: "
  list_name = gets.chomp
  new_list = List.new(list_name)
  new_list.save
  puts "Would you like to add a task to this list? (yes/no)?"
  user_input = gets.chomp
  if user_input == "yes"
    add_current(new_list.id)
    main_menu
  else
    main_menu
  end
end

def add_current(list_id)
  puts "What task would you like to add?"
  user_input = gets.chomp
  puts "\n"
  new_task = Task.new(user_input, list_id)
  main_menu
end

def finish_task
  Task.all.each_with_index do |task, index|
    puts "#{index + 1}. #{task.name}"
  end
  puts "What task would you like to mark as finished?"
  user_input = gets.chomp.to_i - 1
  mark_done(Task.all[user_input].name)
end

def add_task
  puts "Add Task: "
  task_input = gets.chomp
  puts "Does this belong to an exisiting list? (yes/no)?"
  confirmation = gets.chomp
  if confirmation == "yes"
    List.all.each_with_index do |list, index|
      puts "#{(index + 1)} #{list.name}"
    end
    puts "Which list does it belong to?"
    list_choice = gets.chomp.to_i - 1
    new_task = Task.new(task_input, list_choice)
    main_menu
  else
    add_list_for_task(task_input)
  end
end

def add_list_for_task(task_input)
  print "Add List: "
  list_name = gets.chomp
  new_list = List.new(list_name)
  new_list.save
  new_task = Task.new(task_input, new_list.id)
  main_menu
end

# def edit_list
#   puts "What list would you like to edit?"
#   List.all.each_with_index do |list, index|
#       puts "#{(index + 1)} #{list.name}"
#     end
#   user_input = gets.chomp.to_i - 1
#   puts "Press 'e' to edit the list or 'd' to delete it."
#   user_choice = gets.chomp
#   if user_choice == 'd'
#     # delete list
#   else
#     List.list_tasks(user_input).each_with_index do |task, index|
#       puts "#{index + 1}: #{task}"
#     end
#     #p List.all[user_input].list_tasks(user_input).length
#     # List.all[user_input].list_tasks(user_input).each_with_index do |task, index|
#     #   puts "#{index + 1} #{task}"
#     # end
#   end
#   # main_menu
#end
reset_tables
