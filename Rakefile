require 'fileutils'

HOME_DIR = "#{File.dirname(__FILE__)}"


  task :ensure_gems do
    puts `(bundle install --system)`
  end

namespace :start do

      task :api do
        puts `(shotgun -p 4987 api.rb)`
      end

      task :web do
        puts `(shotgun -p 4567 web.rb)`
      end

      task :mock do
      end

  end

namespace :stop do

  task :api do
  end

  task :web do
    kill_process_by_name('sinatra')
  end

  task :mock do
  end

end

def kill_process_by_name(name)
  puts "Trying to stop #{name}"
  `kill \`ps -ef | grep #{name} | grep -v grep | awk '{print $2}'\``
end

