require 'list'
require 'rspec'
require 'pg'

DB = PG.connect({:dbname => 'to_do_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lists *;")
  end
end

describe List do
  it 'is initialized with a name' do
    list = List.new('Epicodus stuff')
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new('Epicodus stuff')
    list.name.should eq 'Epicodus stuff'
  end

  it 'is the same list if it has the same name' do
    list1 = List.new('Epicodus stuff')
    list2 = List.new('Epicodus stuff')
    list1.should eq list2
  end

  it 'starts off with no lists' do
    List.all.should eq []
  end

  it 'lets you save lists to the database' do
    list = List.new('Epicodus stuff')
    list.save
    List.all.should eq [list]
  end

  it 'sets its ID when you save it' do
    list = List.new('Epicodus stuff')
    list.save
    list.id.should be_an_instance_of Fixnum # Fixnum is Ruby's name for integers below a certain very large size
  end

  it 'can be initialized with its database ID' do
    list = List.new('Epicodus stuff', 1)
    list.should be_an_instance_of List
  end

  # it 'stores a new task to the appropriate list' do
  #   list = List.new('Epicodus stuff')
  #   list.save
  #   test_task = Task.new('Learn SQL', list.id)
  #   test_task.save
  #   List.list_tasks(list.id).should eq [test_task.name]
  # end
end
