namespace :signonotron do
  desc "Start signonotron (for integration tests)"
  task :start => :stop do
    gem_root = Pathname.new(File.dirname(__FILE__)) + '..' + '..'
    FileUtils.mkdir_p(gem_root + 'tmp')
    Dir.chdir gem_root + 'tmp' do
      if File.exist? "signonotron2"
        Dir.chdir "signonotron2" do
          puts `git clean -fdx`
          puts `git fetch origin`
          puts `git reset --hard origin/master`
        end
      else
        puts `git clone git@github.com:alphagov/signonotron2`
      end
    end

    Dir.chdir gem_root + 'tmp' + 'signonotron2' do
      env_stuff = '/usr/bin/env -u BUNDLE_GEMFILE -u BUNDLE_BIN_PATH -u RUBYOPT RAILS_ENV=test'
      puts `#{env_stuff} bundle install --path=#{gem_root + 'tmp' + 'signonotron2_bundle'}`
      FileUtils.cp gem_root.join('spec', 'fixtures', 'integration', 'signonotron2_database.yml'), File.join('config', 'database.yml')
      puts `#{env_stuff} bundle exec rake db:drop db:create db:schema:load`

      puts "Starting signonotron instance in the background"
      fork do
        Process.daemon(true)
        exec "#{env_stuff} bundle exec rails s -p 4567"
      end
    end
  end

  desc "Stop running signonotron (for integration tests)"
  task :stop do
    pid_output = `lsof -Fp -i :4567`.chomp
    if pid_output =~ /\Ap(\d+)\z/
      puts "Stopping running instance of Signonotron (pid #{$1})"
      Process.kill(:INT, $1.to_i)
    end
  end
end

