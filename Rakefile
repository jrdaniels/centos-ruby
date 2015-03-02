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

task :clean do
  sh 'sudo rm -rf tmp/*'
end
