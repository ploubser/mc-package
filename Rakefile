require "spec/spec_helper"
require "rake"
require "rspec/core/rake_task"

desc "Run mc-package tests"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "spec/unit/*_spec.rb"
  t.rspec_opts = "--format s --color --backtrace"
end

task :default => :test
