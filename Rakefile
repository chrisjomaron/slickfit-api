require 'fileutils'

HOME_DIR = "#{File.dirname(__FILE__)}"


  task :ensure_gems do
    puts `(bundle install --system)`
  end

namespace :start do

      task :api do
        puts `(export environment=prod && shotgun -p 4987 api.rb)`
      end

end

namespace :start_dev do

      task :api do
        puts `(export environment=dev && shotgun -p 4987 api.rb)`
      end

end

namespace :stop do

  task :api do
    kill_process_by_name('api.rb')	  
  end

end

def kill_process_by_name(name)
  puts "Trying to stop #{name}"
  `kill \`ps -ef | grep #{name} | grep -v grep | awk '{print $2}'\``
end

