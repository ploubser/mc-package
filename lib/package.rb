module MCPackage
  class Package
    require 'fileutils'
    require 'tmpdir'

    #libdir needs to be set by calling super from the package type sub class
    attr_accessor :name, :version, :tmp_dir, :post_install, :plugin_type, :libdir,
      :dependencies, :agent, :application, :dependencies

    #TODO: Consider adding dependencies
    def initialize(name, version, libdir, post_install = nil)
      @name = name
      @version = (version.is_a? String) ? version : version.to_s
      @post_install = post_install
      @tmp_dir = Dir.mktmpdir "mc-package"
      @libdir = libdir
      @dependencies = nil
      @agent = false
      @application = false
      @dependencies = false
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
