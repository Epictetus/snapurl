# -*- ruby -*-

$:.unshift File::join(File::dirname(__FILE__), 'lib')

require 'rubygems'
require 'hoe'
require './lib/snapurl.rb'

Hoe.new('snapurl', SnapUrl::VERSION) do |p|
  p.rubyforge_name = 'SnapUrl'
  p.developer('Juris Galang', 'jurisgalang@gmail.com')
end

desc "Remove additional work directories for build."
task :clean do
  sh "rm -rf tmp"
end

desc "Installs RubyCocoa (you only need to do this once)"
task :install_cocoa => :clean do
  fail "RubyCocoa might not work for Ruby version > 1.8.7, you are using version #{RUBY_VERSION}" unless RUBY_VERSION <= "1.8.7"
  RUBYCOCOA = "RubyCocoa-0.13.2"
  sh "mkdir -p tmp && tar zxf thirdparty/#{RUBYCOCOA}.tgz -C tmp" 
  Dir.chdir("tmp/#{RUBYCOCOA}") do
    sh "ruby install.rb config"
    sh "ruby install.rb setup"
    sh "ruby install.rb install"
  end
end


# vim: syntax=Ruby
