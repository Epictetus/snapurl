require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "snapurl"
    gem.summary     = %Q{Take snapshots of websites.}
    gem.description = %Q{
      Take snapshots of websites. This is a Ruby/RubyCocoa port of the 
      webkit2png.py script by Paul Hammond 
      (http://www.paulhammond.org/webkit2png/) with some minor modifications -
      Generates a set of image files representing the thumbnail, clipped, 
      and full-sized view of a web page in PNG format. }
    gem.email       = "jurisgalang@gmail.com"
    gem.homepage    = "http://github.com/jurisgalang/snapurl"
    gem.authors     = ["Juris Galang", "Michael Kohl", "Joel Chippindale"]
    gem.executables = [ 'snapurl' ]
    gem.files       = FileList["[A-Z]*.*", "History", "{bin,generators,lib,test,spec}/**/*"]
    gem.add_development_dependency "thoughtbot-shoulda"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "snapurl #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
