# The Marionette Collective Package Tool
#
# Module to build packages from common mcollective agent/client patterns.
# All package classes must extend MCPackage::Package and call its initialize method.
# A libdir path must be set specific to the package implementation
module MCPackage
  require 'rubygems'
  require 'facter'
  require 'fpm/program'
  require 'package'

  Dir[File.dirname(__FILE__) + "/**/*.rb"].each {|f| require f}

  # Checks if package implementation inherits from MCPackage::Package,
  # calls super and sets libdir. It will then create the packages and
  # clean up the temp directories
  def self.create_package(options)
    options[:package_type] = Facter.value("osfamily").capitalize unless options[:package_type]
    options[:name] = File.basename(Dir.pwd) unless options[:name]

    begin
      mc_package = self.const_get(options[:package_type]).new(options[:name], options[:iteration],
        options[:postinstall], options[:vendor])

      # Check if package implementation extends MCPackage::Package
      raise "#{mc_package.class.to_s} must extend MCPackage::Package. Aborting" unless
        mc_package.class.superclass ==  MCPackage::Package

      # Check if MCPackage::Package.initialize() has been called.
      raise "#{mc_package.class.to_s} must call MCPackage::Package.initialize(). Aborting" unless mc_package.initialized

      # Check if libdir has been set
      raise "libdir must be set in super() call in class #{mc_package.class.to_s}. Aborting" unless mc_package.libdir

      mc_package.create_package
    rescue Exception => e
      puts e.to_s
    else
      mc_package.clean_up if mc_package
    end
  end
end
