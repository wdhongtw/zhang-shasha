require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << 'test' << 'lib'
  task.test_files = FileList['test/test*.rb']
  task.verbose = true
end

task :default do
end
