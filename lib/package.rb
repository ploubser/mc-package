module MCPackage
    class Package

        require 'fileutils'
        require 'tmpdir'

        attr_accessor :name, :version, :tmp_dir, :plugin_dir, :post_install, :plugin_type

        def initialize(name, version, post_install = nil)
            @name = name
            @version = version
            @post_install = post_install
            @tmp_dir = Dir.mktmpdir "mc-package"
            package_type
        end

        def package_type
            #Normal application/agent definition
            ptype = nil
            if File.directory?("#{Dir.pwd}/agent") && File.directory?("#{Dir.pwd}/application")
                ptype = :agent
            end
            prepare_package ptype
        end

        def clean_up
            FileUtils.rm_r @tmp_dir
        end

        def prepare_package(type)
            case type
            when :agent
                create_package_dirs
            else
                raise "Undefined Plugin Type"
            end
        end

        def create_package_dirs
            case self.class.to_s
            when /redhat/i
                FileUtils.mkdir_p "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
                FileUtils.cp_r "agent", "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
                FileUtils.cp_r "application", "#{@tmp_dir}/usr/libexec/mcollective/mcollective"
                @plugin_dir = "usr/libexec/mcollective/mcollective"
            when /debian/i
                FileUtils.mkdir_p "#{@tmp_dir}/usr/share/mcollective/plugins/mcollective"
                FileUtils.cp_r "agent", "#{@tmp_dir}/usr/share/mcollective/plugins/mcollective"
                FileUtils.cp_r "application", "#{@tmp_dir}/usr/share/mcollective/plugins/mcollective"
                @plugin_dir = "usr/share/mcollective/plugins/mcollective"
            end
        end
    end
end
