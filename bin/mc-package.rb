#!/usr/bin/env ruby

require 'mc-package'
require 'optparse'

@options = {:iteration => 1,
            :ostype => nil,
            :name => nil,
            :post_install => nil}

OptionParser.new do |opts|
  opts.banner = "Usage: mc-package [options]"

  opts.on("-i", "--iteration ITERATION", "Sets the package iteration.") do |iteration|
    @options[:iteration] = iteration
  end

  opts.on("-o", "--ostype OSTYPE", "Sets operating system package type (RedHat or Debian.") do |ostype|
    @options[:ostype] = ostype
  end

  opts.on("-n", "--name NAME", "Sets package name.") do |name|
    @options[:name] = name
  end

  opts.on("-p", "--postinstall SCRIPT", "Sets script to run on package post install.") do |script|
    @options[:postinstall] = script
  end
end.parse!

MCPackage.create_package @options
