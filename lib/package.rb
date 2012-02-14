module MCPackage
  class Package
    require 'fileutils'
    require 'tmpdir'

    #libdir needs to be set by calling super from the package type sub class
    attr_accessor :name, :tmp_dir, :post_install, :plugin_type, :libdir,
      :dependencies, :agent, :application, :dependencies, :meta, :iteration

    def initialize(name, libdir, iteration, post_install = nil)
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
      package_type
    end

    def package_type

      if File.directory?(File.join(Dir.pwd, "util"))
        prepare_package :common
      end

      if File.directory?(File.join(Dir.pwd, "agent"))
        prepare_package :agent
      end

      if File.directory?(File.join(Dir.pwd, "application"))
        prepare_package :application
      end
    end

    def clean_up
      FileUtils.rm_r @tmp_dir
    end

    def prepare_package(type)
      tmpdir = File.join(@tmp_dir, @libdir)

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
