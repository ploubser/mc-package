module MCPackage
    class Package

        require 'fileutils'
        require 'tmpdir'

        attr_accessor :name, :version, :tmp_dir, :post_install, :plugin_type, :mc_path

        def initialize(name, version, mc_path, post_install = nil)
            @name = name
            @version = version
            @post_install = post_install
            @tmp_dir = Dir.mktmpdir "mc-package"
            @mc_path = mc_path
            package_type
        end

        def package_type
            #Normal application/agent definition
            if File.directory?("#{Dir.pwd}/agent") && File.directory?("#{Dir.pwd}/application")
                prepare_package :agent
            end
        end

        def clean_up
            FileUtils.rm_r @tmp_dir
        end

        def prepare_package(type)
            case type
            when :agent
                FileUtils.mkdir_p "#{@tmp_dir}/#{@mc_path}"
                FileUtils.cp_r "agent", "#{@tmp_dir}/#{@mc_path}"
                FileUtils.cp_r "application", "#{@tmp_dir}/#{@mc_path}"
            else
                raise "Undefined Plugin Type"
            end
        end
    end
end
