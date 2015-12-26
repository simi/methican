require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = '*_test.rb'
end

desc 'Compile parser via canopy'
task :compile do
  `node_modules/canopy/bin/canopy methic_parser.peg --lang ruby`
end

task :default => [:compile, :test]
