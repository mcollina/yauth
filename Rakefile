require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "yauth"
  gem.homepage = "http://github.com/mcollina/yauth"
  gem.license = "MIT"
  gem.summary = %Q{A warden strategy for yaml based authentication}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "matteo@matteocollina.com"
  gem.authors = ["Matteo Collina"]
  gem.add_runtime_dependency 'warden', '~> 1.0'
  gem.add_runtime_dependency 'thor', '~> 0.14.0'
  gem.add_development_dependency 'test_notifier', '~> 0.3.6'
  gem.add_development_dependency 'autotest', '~> 4.4'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "yauth #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
