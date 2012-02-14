module MCPackage
  class Package
    require 'fileutils'
    require 'tmpdir'

    #mc_path needs to be set by calling super from the package type sub class
    attr_accessor :name, :version, :tmp_dir, :post_install, :plugin_type, :mc_path,
      :dependencies, :agent, :application, :dependencies

    #TODO: Consider adding dependencies
    def initialize(name, version, mc_path, post_install = nil)
      @name = name
      @version = (version.is_a? String) ? version : version.to_s
      @post_install = post_install
      @tmp_dir = Dir.mktmpdir "mc-package"
      @mc_path = mc_path
      @dependencies = nil
      @agent = false
      @application = false
      @dependencies = false
      package_type
    end

    def package_type

      if File.directory?(File.join(Dir.pwd, "common"))
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
      tmpdir = File.join(@tmp_dir, @mc_path)

      FileUtils.mkdir_p tmpdir

      case type
      when :common
        FileUtils.cp_r "common", tmpdir
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
