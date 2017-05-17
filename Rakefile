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

desc 'Build gem file'
task :buildgem do
  sh 'gem build zss.gemspec'
end

desc 'Delete documentation'
task :cleandoc do
  sh 'rm -rf .yardoc doc'
end

desc 'Delete gem file'
task :cleangem do
  sh 'rm -rf *.gem'
end

desc 'Clean all build product, like doc and gem'
task clean: [:cleandoc, :cleangem] do
end
