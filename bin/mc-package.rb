#!/usr/bin/env ruby

require 'mc-package'
require 'optparse'

@options = {:iteration => 1,
            :package_type => nil,
            :name => nil,
            :post_install => nil,
            :vendor => nil
}

OptionParser.new do |opts|
  opts.banner = "Usage: mc-package [options]"

  opts.on("-i", "--iteration ITERATION", "Sets the package iteration.") do |iteration|
    @options[:iteration] = iteration
  end

  opts.on("-o", "--packagetype PACKAGETYPE", "Sets package type.") do |package_type|
    @options[:package_type] = package_type
  end

  opts.on("-p", "--postinstall SCRIPT", "Sets script to run on package post install.") do |script|
    @options[:postinstall] = script
  end

  opts.on("-v", "--vendor VENDOR", "Sets package vendor.") do |vendor|
    @options[:vendor] = vendor
  end
end.parse!

MCPackage.create_package @options
