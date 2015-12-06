#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

desc "Run all cukes in features/"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:features]
