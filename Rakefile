require 'pathname'

task default: 'docker:build'

namespace :docker do
  image_name = 'maxmeyer/centos-rails'
  container_name = 'rails1'

  desc 'Build docker image'
  task :build, :nocache do |_, args|
    nocache = args[:nocache]

    cmdline = []
    cmdline << 'docker'
    cmdline << 'build'
    cmdline << '--no-cache=true' if nocache
    cmdline << "-t #{image_name}"
    cmdline << '.'

    sh cmdline.join(' ')
  end

  desc 'Run docker container'
  task :run, :command do |_, task_args|
    command = task_args[:command]

    cwd = Pathname.new(Dir.getwd)
    tmp_dir = cwd + Pathname.new('tmp')
    data_dir = tmp_dir + Pathname.new('data')
    log_dir = tmp_dir + Pathname.new('log')
    sites_dir = tmp_dir + Pathname.new('sites')

    FileUtils.mkdir_p data_dir
    FileUtils.mkdir_p log_dir
    FileUtils.mkdir_p sites_dir

    args =[]
    args << '-it'
    args << '--rm'
    args << "--name #{container_name}"
    args << "-v #{data_dir}:/var/www"
    args << "-v #{log_dir}:/var/log"
    args << "-v #{sites_dir}:/etc/rails/sites-enabled"

    cmdline = []
    cmdline << 'docker'
    cmdline << 'run'
    cmdline.concat args
    cmdline << image_name
    cmdline << command if command

    sh cmdline.join(' ')
  end
end

namespace :machine do
  desc 'Install machine'
  task :install, :name, :domain_name do |_, args|
    name        = args[:name]
    domain_name = args[:domain_name]

    fail ArgumentError, 'Name argument is missing' if name.nil?

    sh 'sudo cp rails@.service /etc/systemd/system/'
    sh 'sudo systemctl daemon-reload'
    sh 'sudo groupadd -f deploy'

    sh 'sudo machinectl pull-dkr --dkr-index-url https://index.docker.io --verify=no --force maxmeyer/centos-rails'
    sh "sudo systemctl enable rails@#{name}"

    sh "sudo install -m 2775 -d -g deploy /srv/machines/#{name}"
    sh "sudo install -d /etc/ssl/machines/#{name}"
    sh "sudo install -d /var/log/machines/#{name}"

    sh "sudo install -m 644 -D environment.conf /etc/default/machines/#{name}.conf"
    sh "sudo install -m 644 -D default.conf /etc/machines/#{name}/sites-enabled/default.conf"
    sh "sudo install -m 644 -D ssl.conf /etc/machines/#{name}/other-config/ssl.conf"
    sh "sudo install -m 644 -D logrotate.conf /etc/logrotate.d/#{name}.conf"

    sh "sudo sed -i -e 's/www_example_org/#{name}/g' /etc/logrotate.d/#{name}.conf"
    sh "sudo sed -i -e 's/www_example_org/#{name}/g' /etc/default/machines/#{name}.conf"
    sh "sudo sed -i -e 's/example.org/#{domain_name}/g' /etc/machines/#{name}/sites-enabled/default.conf" if domain_name
  end

  task :status, :name do |_, args|
    name = args[:name]
    fail ArgumentError, 'Name argument is missing' if name.nil?

    sh "sudo systemctl status rails@#{name}"
  end

  %i(start stop restart).each do |cmd|
    desc "#{cmd.to_s.capitalize} service"
    task cmd, :name do |_, args|
      name = args[:name]
      fail ArgumentError, 'Name argument is missing' if name.nil?

      sh "sudo systemctl #{cmd} rails@#{name}"
      Rake::Task['machine:status'].invoke(args[:name])
    end
  end
end
