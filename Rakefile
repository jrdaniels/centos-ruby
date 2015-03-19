require 'pathname'

task default: 'docker:build'

namespace :docker do
  image_name = 'feduxorg/centos-ruby'
  container_name = 'ruby1'
  docker_file    = 'files/docker/latest/Dockerfile'

  desc 'Build docker image'
  task :build, :nocache do |_, args|
    nocache = args[:nocache]

    cmdline = []
    cmdline << 'docker'
    cmdline << 'build'
    cmdline << '--no-cache=true' if nocache
    cmdline << "-t #{image_name}"
    cmdline << "-f #{docker_file}"
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

namespace :templates do
  desc 'Copy templates'
  task :copy do
    Rake::FileList.new('files/**/*').select { |f| File.directory? f }.each do |d|
      files = Rake::FileList.new("templates/root/*").to_a
      files += Rake::FileList.new("templates/root/.???*").to_a
      FileUtils.cp(files, d)

      type = File.basename(File.dirname(d))
      files = Rake::FileList.new("templates/#{type}/*").to_a
      files += Rake::FileList.new("templates/#{type}/.???*").to_a
      FileUtils.cp(files, d)
    end
  end
end
