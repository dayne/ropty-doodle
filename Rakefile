require 'rake/testtask'

# Load custom tasks from the 'lib/tasks' directory, if you have any
Dir.glob('lib/tasks/*.rake').each { |r| import r }

# Define a task to start the server using the script in the bin directory
desc 'Start the ropty server'
task :start do
  sh 'bin/start_server'
end

# Define a test task
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# Default task if just 'rake' is run
task default: :test
