require 'rake/testtask'
require 'yard'

Rake::TestTask.new do |task|
  task.libs << 'test' << 'lib'
  task.test_files = FileList['test/test*.rb']
  task.verbose = true
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = []
end
