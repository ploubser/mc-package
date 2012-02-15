# The Marionette Collective Package Tool
#
# Base class which all external package implementations extend.
module MCPackage
  class Package
    require 'fileutils'
    require 'tmpdir'

    # libdir needs to be set by calling super from the package type sub class
    attr_accessor :name, :tmp_dir, :post_install, :plugin_type, :libdir
    attr_accessor :dependencies, :agent, :application, :dependencies, :meta, :iteration, :initialized

    def initialize(name, libdir, iteration = "1", post_install = nil)
      raise "Package needs to implement create_package(). Aborting" unless self.methods.include? "create_package"

      @name = name
      @meta = MCPackage::DDL.new(name).meta
      @post_install = post_install
      @tmp_dir = Dir.mktmpdir "mc-package"
      @libdir = libdir
      @dependencies = nil
      @agent = false
      @application = false
      @dependencies = false
      @iteration = (iteration.is_a? String) ? iteration : iteration.to_s
      @initialized = true
      identify_packages
    end

    # Identify packages to be created
    def identify_packages
      prepare_package :common if File.directory?(File.join(Dir.pwd, "util"))
      prepare_package :agent if File.directory?(File.join(Dir.pwd, "agent"))
      prepare_package :application if File.directory?(File.join(Dir.pwd, "application"))
    end

    # Remove temp directories. Called after a successful package run.
    def clean_up
      FileUtils.rm_r @tmp_dir
    end

    # Create temp dirs for the identified packages
    def prepare_package(type)
      tmpdir = File.join(@tmp_dir, @libdir)
      # TODO: Find another tmpdir implementation that works on ruby 1.8.5
      FileUtils.mkdir_p tmpdir

      case type
      when :common
        FileUtils.cp_r "util", tmpdir
        @dependencies = true
      when :agent
        FileUtils.cp_r "agent", tmpdir
        @agent = true
      when :application
        FileUtils.cp_r "application", tmpdir
        @application = true
      else
        raise "Undefined Plugin Type"
      end
    end
  end
end
